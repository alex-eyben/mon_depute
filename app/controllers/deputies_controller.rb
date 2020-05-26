class DeputiesController < ApplicationController
  def show
    @deputy = Deputy.find(params[:id])
    @votes = @deputy.votes
  end
end
