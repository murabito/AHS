class PatientController < ApplicationController
  before_action :authenticate_user!

  def show
    @patient = RedoxApi::Patient.new(params["patient"])
  end
end
