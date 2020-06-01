require 'open-uri'
require 'csv'

class DeputiesController < ApplicationController
  skip_before_action :authenticate_user!, only:  [ :results, :show]

  def show
    @deputy = Deputy.find(params[:id])
    @tag = params[:tag]
    if @tag
      @positions = @deputy.positions.select { |position| position.law.tag_list.include? params[:tag] }
      @participationRate = getParticipationRateFiltered(@deputy, @tag)
    else
      @positions = @deputy.positions.order(:law_id)
      @participationRate = getParticipationRate(@deputy)
    end
    @user = current_user
  end

  def getParticipationRate(deputy)
    positionsCount = deputy.positions.count
    absentVotes = deputy.positions.select { |position| position.votant == false }
    absentCount = absentVotes.count
    (1 - (absentCount/positionsCount)) * 100
  end

  def getParticipationRateFiltered(deputy, tag)
    positions = deputy.positions.select { |position| position.law.tag_list.include? tag }
    positionsCount = positions.count
    absentVotes = positions.select { |position| position.votant == false }
    absentCount = absentVotes.count
    (1 - (absentCount/positionsCount)) * 100
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
    redirect_to deputy_path(@deputy)
  end

  def follow
  
    @user = current_user
    @deputy = Deputy.find(params[:id])
    @deputy.liked_by @user
    redirect_to deputy_path(@deputy)
  end

  def unfollow
    
    @user = current_user
    @deputy = Deputy.find(params[:id])
    @deputy.unliked_by @user
    redirect_to request.referrer
  end

  def results
    query = params[:query]
    url = "https://api-adresse.data.gouv.fr/search/?q=#{URI.escape(query)}"
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
