class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def searches
    @recent_views = RecentView.where(user_id: current_user.id)
  end
end
