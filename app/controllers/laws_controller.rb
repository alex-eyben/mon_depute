class LawsController < ApplicationController
  def show
    @law = Law.find(params[:id])
  end

  def new
    @law = Law.new
  end

  def create
    @law = Law.new(law_params)
    if @law.save
      redirect_to root_path
    else
      render :new
    end
    ImportPositionsJob.perform_now(10000,[@law.scrutin_id])
  end

  private

  def law_params
    params.require(:law).permit(:title, :content, :ressource_link, :current_status, :last_status_update, :scrutin_id)
  end
end
