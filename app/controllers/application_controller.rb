class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :followedDeputies

  def followedDeputies
    if current_user
      @user = current_user
      deputy_array = @user.votes.for_type(Deputy)
      ids = []
      deputy_array.each do |position|
        ids << position.votable_id
      end
      @deputies = []
      ids.each do |id|
        @deputies << Deputy.find(id)
      end
      @deputies
    end
  end
end
