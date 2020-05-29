class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @deputies = [Deputy.first, Deputy.last]
    @user = current_user
  end
end
