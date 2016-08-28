class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def searches
    RedoxApi::Core::RequestService.authenticated_response
  end
end
