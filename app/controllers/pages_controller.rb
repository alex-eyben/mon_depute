class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    before_action :authenticate_user!
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
