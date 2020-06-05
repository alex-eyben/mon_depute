require 'open-uri'
require 'csv'

class DeputiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:results, :show]

  def show
    @deputy = Deputy.find(params[:id])
    @tag = params[:tag]
    @participationRate = getParticipationRate(@deputy).fdiv(100)
    if @tag
      positions = @deputy.positions.order(date: :desc)
      @positions = positions.select { |position| position.law.tag_list.include? params[:tag] }
      @filteredParticipationRate = getParticipationRateFiltered(@deputy, @tag).fdiv(100)
    else
      @positions = @deputy.positions.order(date: :desc)
    end
    @user = current_user
    @frondingRate = (100 - @deputy.fronding).fdiv(100)
    @topTags = getTopTags(5)
    @yearlyRevenue = @deputy.yearly_revenue / 1000
  end

  # string.split(" ").reject{ |word| word == "-"}
  # array.map(&:capitalize)
  # array.unshift("#").join

  def getTopTags(number)
    topTags = []
    ActsAsTaggableOn::Tag.most_used(number).each do |tag|
      topTags << tag.name
    end
    return topTags
  end

  def getParticipationRate(deputy)
    positionsCount = deputy.positions.count
    absentVotes = deputy.positions.select { |position| position.votant == false }
    absentCount = absentVotes.count
    ((1 - absentCount.fdiv(positionsCount)) * 100).truncate
  end

  def getParticipationRateFiltered(deputy, tag)
    positions = deputy.positions.select { |position| position.law.tag_list.include? tag }
    positionsCount = positions.count
    absentVotes = positions.select { |position| position.votant == false }
    absentCount = absentVotes.count
    ((1 - absentCount.fdiv(positionsCount)) * 100).truncate
  end

  def like
    @user = current_user
    @position = Position.find(params[:position_id])
    @deputy = Deputy.find(params[:id])
    # @user.likes @position
    if params[:like] == "true"
      @user.likes @position
    else
      @user.dislikes @position
    end
    flash[:notice] = "Merci d'avoir voté !"
    redirect_to deputy_path(@deputy)
  end

  def follow
    @user = current_user
    @deputy = Deputy.find(params[:id])
    if @user.voted_for?(@deputy)
      @deputy.unliked_by @user
    else
      @deputy.liked_by @user
    end
    respond_to do |format|
      format.html
      format.json { render json: { is_followed: @user.voted_for?(@deputy) } }
    end
    # redirect_to deputy_path(@deputy)
    # redirect_to request.referrer
    # render :nothing => true
    # render partial: 'followbutton'
  end

  def follow_guest
    @user = current_user
    @deputy = Deputy.find(params[:id])
    @deputy.liked_by @user
    redirect_to deputy_path(@deputy)
  end

  def is_followed
    @deputy = Deputy.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: { is_followed: @user.voted_for?(@deputy),
                                   deputies: self.followedDeputies } }
    end
    # get_followed_deputies
  end

  def get_followed_deputies
    respond_to do |format|
      format.html
      format.json { render json: { deputies: self.followedDeputies } }
    end
  end
  # def unfollow

  #   @user = current_user
  #   @deputy = Deputy.find(params[:id])
  #   @deputy.unliked_by @user
  #   redirect_to request.referrer
  #   # render partial: 'followbutton'
  # end

  def results
    query = params[:query]
    url = "https://api-adresse.data.gouv.fr/search/?q=#{URI.escape(query)}"
    redirect_to root_path and return if JSON.parse(open(url).read)["features"].empty?

    citycode = JSON.parse(open(url).read)["features"][0]["properties"]["citycode"]

    file_path = Rails.root.join("db/csv", "circonscriptions.csv")
    options = { col_sep: ";", headers: :first_row }
    circo = ""
    dep = ""
    CSV.foreach(file_path, options).with_index do |row, i|
      unless row[3].nil?
        if row[3].include?(citycode)
          dep = row[1]
          circo = row[2]
        end
      end
    end
    @deputy = Deputy.where(circonscription: circo.to_i, department: dep.to_i).first
    redirect_to root_path and return if @deputy.nil?
    redirect_to deputy_path(@deputy)
  end
end
