class PatientController < ApplicationController
  before_action :authenticate_user!

  def show
    @patient = Patient.find_by_nist_id(params["patient_id"])

    clinical_summary_request_body = clinical_summary_body_json(params["patient_id"])

    response = RedoxApi::Core::RequestService.request("POST", "/query", body: clinical_summary_request_body)

    if successful_response?(response) && successful_clinical_summary_query?(response)
      flash.clear

      @clinical_summary = RedoxApi::ClinicalSummary.new(response.data)
      # @patient = RedoxApi::Patient.new(response.data["Header"]["Patient"])

      save_to_recent_views(@clinical_summary, @patient)
    else
      flash.alert = "This patient's clinical summary was not successfully returned from this EHR. Please search again."
      render :search
    end
  end

  def search
  end

  def retrieve
    patient_search_data = patient_query_body_json

    response = RedoxApi::Core::RequestService.request("POST", "/query", body: patient_search_data)

    if successful_response?(response) && successful_patient_query?(response)
      flash.clear

      @patient = RedoxApi::Patient.new(response.data["Patient"])
      save_patient(@patient)
      
      redirect_to patient_path(patient_id: @patient.id)
    else
      flash.alert = "This data did not return a succesful patient query. Please re-enter patient data."
      render :search
    end
  end

  def save_patient(patient_data)
    return if patient_exists?(patient_data)
    patient = Patient.new
    patient.nist_id = patient_data.patient_id

    # Pulling this data from clinical summary for now, as it is required / reliable

    # patient.ssn = patient_data.ssn
    # patient.last_name = patient_data.last_name
    # patient.dob = patient_data.dob
    # patient.first_name = patient_data.first_name

    patient.save
  end

  def patient_exists?(patient)
    !!(Patient.find_by_nist_id(patient.id))
  end

  def save_to_recent_views(clinical_summary, patient)
    recent_view = RecentView.new
    recent_view.user_id = current_user.id

    # TODO - Finds patient by nist id for now.
    recent_view.patient_id = patient.id

    # TODO - EHR system is hard coded for now. 
    recent_view.ehr_system_id = 1

    recent_view.save
  end

  def patient_query_body_json
    body = {
      "Meta": {
        "DataModel": "PatientSearch",
        "EventType": "Query",
        "EventDateTime": timestamp,
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
          "LastName": params["last_name"],
          "DOB": params["dob"],
          "SSN": params["ssn"],
        }
      }
    }

    body = body.to_json
  end

  def clinical_summary_body_json(patient_id)
    body = {
      "Meta": {
        "DataModel": "Clinical Summary",
        "EventType": "Query",
        "EventDateTime": timestamp,
        "Test": true,
        "Destinations": [
          {
            "ID": "ef9e7448-7f65-4432-aa96-059647e9b357",
            "Name": "Clinical Summary Endpoint"
          }
        ]
      },
      "Patient": {
        "Identifiers": [
          {
            "ID": patient_id,
            "IDType": "NIST"
          }
        ]
      }
    }

    body = body.to_json
  end

  def successful_patient_query?(response)
    !!response.data["Patient"]
  end
  
  def successful_clinical_summary_query?(response)
    !!response.data["Header"]["Document"]
  end

  def successful_response?(response)
    response.status >= 200 && response.status < 300
  end

  def timestamp
    Time.new.utc.iso8601
  end
end
