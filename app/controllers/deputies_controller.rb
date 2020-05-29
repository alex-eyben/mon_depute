class DeputiesController < ApplicationController
  def show
    @deputy = Deputy.find(params[:id])
    @positions = @deputy.positions
    @user = current_user
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

  def follow
    @user = current_user
    @deputy = Deputy.find(params[:id])
    @deputy.liked_by @user
    redirect_to dashboard_path
  end

  def results
    # get data from a geocoder search
    query = params[:query]
    result = Geocoder.search(query)

    # get the circonscription number
    if result.empty?
      render 'pages/home'
    else
      city_searched = result.first.data["address"]["city"]
      if city_searched == nil
        city_searched = result.first.data["address"]["town"]
        if city_searched == nil
          city_searched = result.first.data["address"]["village"]
        end
      end

      if result.first.data["address"]["country"] == "France" && !result.first.data["address"]["postcode"].nil?
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
      else
        render 'pages/home'
      end
    end
  end
end
