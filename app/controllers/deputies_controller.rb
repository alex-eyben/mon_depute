class DeputiesController < ApplicationController
  def show
    @deputy = Deputy.find(params[:id])
    @votes = @deputy.votes
  end

  def results
    # get data from a geocoder search
    query = params[:query]
    result = Geocoder.search(query) 
    
    # get the circonscription number
    city_searched = result.first.data["address"]["city"]
    commune = Location.where(commune: city_searched).first
    circonscription = commune.circonscription

    # get the deputy
    department = result.first.data["address"]["postcode"][0..1].to_i
    @deputy = Deputy.where(circonscription: circonscription, department: department).first
    redirect_to deputy_path(@deputy)
  end
end
