class DashboardController < ApplicationController
  before_action :authenticate_user!, :except => [:verify]
  
  def verify
    if verification_request?
      if verify_token
        # RedoxApi::Core::RequestService.request("POST", "/", headers: {challenge: params["challenge"]})

        request = RedoxApi::Core::RequestService.build_request('POST', '/verify', 
          :body => { :challenge => params["challenge"] }.to_json,
          :headers => { 'Content-Type' => 'application/json' } )

        redirect_to dashboard_path(challenge: params["challenge"])
      end
    end
  end

  def searches
    @recent_views = RecentView.where(user_id: current_user.id).order(updated_at: :desc).last(5)
    @saved_views = RecentView.where(user_id: current_user.id).where(is_saved: true).order(updated_at: :desc).last(5)
  end

  private

  def verification_request?
    !!params["challenge"]
  end

  def verify_token
    params["verification-token"] == ENV["REDOX_SECRET"]
  end
end
