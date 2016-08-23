class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def searches
    response = RedoxApi::Core::RequestService.patient_query("101-01-0001")
  end

  def patient_search
  end

  def retrieve_patient
    ssn = params["ssn"]
    redirect_to '/patient'
  end
end
