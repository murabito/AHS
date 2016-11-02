class PatientController < ApplicationController
  before_action :authenticate_user!

  def search
  end

  def retrieve
    ehr_systems = EhrSystem.all 

    ehr_systems.each do | ehr_system |

      patient_search_request_body = patient_query_body_json(ehr_system.redox_id, ehr_system.name)

      response = RedoxApi::Core::RequestService.request("POST", "/query", body: patient_search_request_body)

      if successful_patient_query?(response)
        flash.clear

        @patient = RedoxApi::Patient.new(response.data["Patient"])
        save_patient(ehr_system.id, @patient)
      end

      clinical_summary_request_body = clinical_summary_body_json(ehr_system.redox_id, ehr_system.name, @patient.id)

      response = RedoxApi::Core::RequestService.request("POST", "/query", body: clinical_summary_request_body)

      if successful_clinical_summary_query?(response)
        # flash.clear

        @clinical_summary = RedoxApi::ClinicalSummary.new(response.data)
        # @patient = RedoxApi::Patient.new(response.data["Header"]["Patient"])

        save_clinical_summary(@clinical_summary, @patient.id, ehr_system.id)
      end

    # if successful_response?(response) && successful_patient_query?(response)
    #   flash.clear

    #   @patient = RedoxApi::Patient.new(response.data["Patient"])
    #   save_patient(@patient)

    #   redirect_to search_results_path(patient_id: @patient.id)
    # else
    #   flash.alert = "This data did not return a succesful patient query. Please re-enter patient data."
    #   render :search
    # end
    end

    redirect_to search_results_path(patient_id: @patient.id)
  end

  def search_results
    patient_id = Patient.find_by_nist_id(params["patient_id"]).id
    @clinical_summaries = ClinicalSummary.where(patient_id: patient_id)
  end

  def show
    @clinical_summary = ClinicalSummary.find(params["clinical_summary_id"])
    @patient = @clinical_summary.patient
    @ehr_system = @clinical_summary.ehr_system

    # @patient = Patient.find_by_nist_id(params["patient_id"])

    clinical_summary_request_body = clinical_summary_body_json(@ehr_system.redox_id, @ehr_system.name, @patient.nist_id)

    response = RedoxApi::Core::RequestService.request("POST", "/query", body: clinical_summary_request_body)

    if successful_clinical_summary_query?(response)
      flash.clear

      @clinical_summary = RedoxApi::ClinicalSummary.new(response.data)
      @patient = RedoxApi::Patient.new(response.data["Header"]["Patient"])

      # save_clinical_summary(@clinical_summary)
      save_to_recent_views(@clinical_summary, @ehr_system.id)
    else
      flash.alert = "This patient's clinical summary was not successfully returned from this EHR. Please search again."
      render :search
    end
  end

  def save_view
    summary_id = ClinicalSummary.find_by_document_id(params["summary_id"]).id
    recent_view = RecentView.where(clinical_summary_id: summary_id).where(user_id: current_user.id).first
    
    if recent_view.is_saved
      recent_view.is_saved = false
      recent_view.save
    else
      recent_view.is_saved = true
      recent_view.save
    end

    redirect_to '/'
  end

  def patient_exists?(destination_id, patient)
    !!(Patient.where(nist_id: patient.id).where(ehr_system_id: destination_id).first)
  end

  def clinical_summary_exists?(clinical_summary, ehr_id)
    !!(ClinicalSummary.where(document_id: clinical_summary.id).where(ehr_system_id: ehr_id).first)
  end

  def recent_view_exists(clinical_summary, ehr_id)
    summary_id = ClinicalSummary.where(document_id: clinical_summary.id).where(ehr_system_id: ehr_id).first.id

    !!(RecentView.where(clinical_summary_id: summary_id).where(user_id: current_user.id).first)
  end

  def save_patient(destination_id, patient_data)
    return if patient_exists?(destination_id, patient_data)
    patient = Patient.new
    patient.nist_id = patient_data.id

    patient.ssn = patient_data.ssn
    patient.last_name = patient_data.last_name
    patient.dob = patient_data.dob
    patient.first_name = patient_data.first_name
    patient.ehr_system_id = destination_id

    patient.save
  end

  def save_clinical_summary(clinical_summary_data, patient_id, ehr_id)
    return if clinical_summary_exists?(clinical_summary_data, ehr_id)

    clinical_summary = ClinicalSummary.new

    clinical_summary.document_id = clinical_summary_data.id

    # TODO - Finds patient by nist id for now.
    clinical_summary.patient_id = Patient.find_by_nist_id(patient_id).id

    clinical_summary.ehr_system_id = ehr_id

    clinical_summary.save
  end

  def update_viewed_date(clinical_summary)
    summary_id = ClinicalSummary.find_by_document_id(clinical_summary.id).id

    recent_view = RecentView.where(clinical_summary_id: summary_id).where(user_id: current_user.id).first
    
    recent_view.updated_at = DateTime.now
    recent_view.save
  end

  def save_to_recent_views(clinical_summary, ehr_id)
    if recent_view_exists(clinical_summary, ehr_id)
      update_viewed_date(clinical_summary)
    else
      recent_view = RecentView.new
      recent_view.user_id = current_user.id

      recent_view.clinical_summary_id = ClinicalSummary.where(document_id: clinical_summary.id).where(ehr_system_id: ehr_id).first.id

      recent_view.save
    end
  end

  def patient_query_body_json(destination_id, destination_name)
    body = {
      "Meta": {
        "DataModel": "PatientSearch",
        "EventType": "Query",
        "EventDateTime": timestamp,
        "Test": true,
        "Destinations": [
          {
            "ID": destination_id,
            "Name": destination_name
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

  def clinical_summary_body_json(destination_id, destination_name, patient_id)
    body = {
      "Meta": {
        "DataModel": "Clinical Summary",
        "EventType": "Query",
        "EventDateTime": timestamp,
        "Test": true,
        "Destinations": [
          {
            "ID": destination_id,
            "Name": destination_name
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
    successful_response?(response) && !!response.data["Patient"]
  end
  
  def successful_clinical_summary_query?(response)
    successful_response?(response) && !!response.data["Header"]["Document"]
  end

  def successful_response?(response)
    response.status >= 200 && response.status < 300
  end

  def timestamp
    Time.new.utc.iso8601
  end
end
