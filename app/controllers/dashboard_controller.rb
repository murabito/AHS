class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def searches
    RedoxApi::Core::RequestService.authenticated_response
  end

  def patient_search
  end

  def retrieve_patient
    # ssn = params["ssn"]

    patient_data = patient_query_json

    response = RedoxApi::Core::RequestService.request("POST", "/query", body: patient_data)

    if successful_query?(response)
      flash.clear
      redirect_to patient_path(patient: response.data["Patient"])
    else
      flash.alert = "This data did not return a succesful patient query. Please re-enter patient data."
      render :patient_search
    end
  end

  def patient_query_json
    body = {
      "Meta": {
        "DataModel": "PatientSearch",
        "EventType": "Query",
        "EventDateTime": "2016-08-19T14:35:15.783Z",
        "Test": true,
        "Destinations": [
          {
            "ID": "0f4bd1d1-451d-4351-8cfd-b767d1b488d6",
            "Name": "Patient Search Endpoint"
          }
        ]
      },
      "Patient": {
        "Demographics": {
          "LastName": "Bixby",
          "DOB": "2008-01-06",
          "SSN": params["ssn"],
        }
      }
    }

    body = body.to_json
  end

  def successful_query?(response)
    !!response.data["Patient"]
  end
end
