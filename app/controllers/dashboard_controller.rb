class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def searches
    RedoxApi::Core::RequestService.authenticated_response
  end

  def patient_search
  end

  def retrieve_patient
    patient_data = patient_query_json

    response = RedoxApi::Core::RequestService.request("POST", "/query", body: patient_data)

    # @patient = RedoxApi::Patient.new(ssn)
    redirect_to patient_path(@patient)
  end

  def patient_query_json
    ssn = params["ssn"]

    body = {
      "Meta": {
        "DataModel": "PatientSearch",
        "EventType": "Query",
        "Destinations": [
          {
            "ID": "0f4bd1d1-451d-4351-8cfd-b767d1b488d6",
            "Name": "Patient Search Endpoint"
          }
        ]
      },
      "Patient": {
        "Demographics": {
          "SSN": ssn
        }
      }
    }

    body = body.to_json
  end
end
