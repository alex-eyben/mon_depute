class DeputiesController < ApplicationController
  def show
    @deputy = Deputy.find(params[:id])
    @positions = @deputy.positions
  end

  def like
    @user = current_user
    @position = Position.find(params[:position_id])
    @deputy = Deputy.find(params[:id])
    # @user.likes @position
    if params[:like]
      @position.liked_by @user
    else
      @position.disliked_by @user
    end
    redirect_to deputy_path(@deputy)
  end

  def results
    # get data from a geocoder search
    query = params[:query]
    result = Geocoder.search(query)

    # get the circonscription number
    city_searched = result.first.data["address"]["city"]
    if city_searched == nil
      city_searched = result.first.data["address"]["town"]
    end

    department = result.first.data["address"]["postcode"][0..1]
    if department.first == "0"
      searched_department = department[1]
    else
      searched_department = department
    end
    commune = Location.where(commune: city_searched, department: searched_department).first
    circonscription = commune.circonscription

    # get the deputy
    department = result.first.data["address"]["postcode"][0..1].to_i
    @deputy = Deputy.where(circonscription: circonscription, department: department).first
    redirect_to deputy_path(@deputy)
  end
end
