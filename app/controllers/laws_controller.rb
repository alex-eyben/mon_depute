class LawsController < ApplicationController
  def show
    @law = Law.find(params[:id])
  end

  def new
    if current_user.admin
      @law = Law.new
    else 
      redirect_to root_path
    end
  end

  def create
    @law = Law.new(law_params)
    if @law.save
      redirect_to root_path
    else
      render :new
    end
    # ImportPositionsJob.perform_now([@law.scrutin_id])
    # AddTagsToLawJob.perform_now(@law)
    # CountPositionsOnLawJob.perform_now(@law)
    # GetFrondeurStatusJob.perform_now(Deputy.all)
    # GetPresenceScoreJob.perform_now(Deputy.all)
  end

  private

  def law_params
    params.require(:law).permit(:title, :content, :ressource_link, :current_status, :last_status_update, :scrutin_id)
  end
end
