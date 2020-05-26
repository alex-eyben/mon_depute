class DeputiesController < ApplicationController
  def show
    @deputy = Deputy.find(params[:id])
  end
end
