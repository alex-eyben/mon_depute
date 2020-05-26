class LawsController < ApplicationController
  def show
    @law = Law.find(params[:id])
  end
end
