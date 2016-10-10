class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def searches
    @recent_views = RecentView.where(user_id: current_user.id).order(updated_at: :desc).last(5)
    @saved_views = RecentView.where(user_id: current_user.id).where(is_saved: true).order(updated_at: :desc).last(5)
  end
end
