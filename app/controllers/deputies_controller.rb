class DeputiesController < ApplicationController
  def show
    @deputy = Deputy.find(params[:id])
    @votes = @deputy.votes
  end

  def results
    query = params[:query]
    result = Geocoder.search(query)
    departement = result.first.data["address"]["county"]
    city = result.first.data["address"]["city"]
    location = Location.where(commune: city).first
    circonscription = location.circonscription
    @deputy = Deputy.where(circonscription: circonscription).first
  end
end
