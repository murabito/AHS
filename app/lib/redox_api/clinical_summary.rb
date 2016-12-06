module RedoxApi
  class ClinicalSummary
    attr_reader :data
    attr_reader :id

    def initialize(data={})
      @data = data
      @id = document_id
    end

    def document_id
      self.data["Header"]["Document"]["ID"].upcase
    end

    def last_name
      self.data["Header"]["Patient"]["Demographics"]["LastName"].titlecase
    end

    def first_name
      self.data["Header"]["Patient"]["Demographics"]["FirstName"].titlecase
    end

    def dob
      Date.strptime(self.data["Header"]["Patient"]["Demographics"]["DOB"], '%Y-%m-%d')
    end

    def ssn
      self.data["Header"]["Patient"]["Demographics"]["SSN"]
    end

    def sex
      self.data["Header"]["Patient"]["Demographics"]["Sex"]
    end

    def street_address
      self.data["Header"]["Patient"]["Demographics"]["Address"]["StreetAddress"]
    end

    def city
      self.data["Header"]["Patient"]["Demographics"]["Address"]["City"]
    end

    def state
      self.data["Header"]["Patient"]["Demographics"]["Address"]["State"]
    end

    def county
      self.data["Header"]["Patient"]["Demographics"]["Address"]["County"]
    end

    def country
      self.data["Header"]["Patient"]["Demographics"]["Address"]["Country"]
    end

    def zip
      self.data["Header"]["Patient"]["Demographics"]["Address"]["ZIP"]
    end

    def home_phone
      self.data["Header"]["Patient"]["Demographics"]["PhoneNumber"]["Home"]
    end

    def mobile_phone
      self.data["Header"]["Patient"]["Demographics"]["PhoneNumber"]["Mobile"]
    end

    def email
      email_array = self.data["Header"]["Patient"]["Demographics"]["EmailAddresses"]

      email_list = email_array.first["Address"] unless email_array.empty?

      if email_array.count > 1
        email_array.each { | address | email_list = email_list + ', ' + address["Address"] }
      end

      email_list || ''
    end

    def race
      self.data["Header"]["Patient"]["Demographics"]["Race"]
    end

    def ethnicity
      self.data["Header"]["Patient"]["Demographics"]["Ethnicity"]
    end

    def marital_status
      self.data["Header"]["Patient"]["Demographics"]["MaritalStatus"]
    end

    def allergies
      self.data["Allergies"]
    end

    def encounters
      self.data["Encounters"]
    end

    def family_history
      self.data["FamilyHistory"]
    end

    def immunizations
      self.data["Immunizations"]
    end

    def medical_equipment
      self.data["MedicalEquipment"]
    end

    def medications
      self.data["Medications"]
    end

    def plan_of_care_orders
      self.data["PlanOfCare"]["Orders"]
    end

    def plan_of_care_procedures
      self.data["PlanOfCare"]["Procedures"]
    end

    def plan_of_care_encounters
      self.data["PlanOfCare"]["Encounters"]
    end

    def plan_of_care_medication
      self.data["PlanOfCare"]["MedicationAdministration"]
    end

    def plan_of_care_supplies
      self.data["PlanOfCare"]["Supplies"]
    end

    def plan_of_care_services
      self.data["PlanOfCare"]["Services"]
    end

    def problems
      self.data["Problems"]
    end

    def procedures
      self.data["Procedures"]
    end

    def results
      self.data["Results"]
    end

    def social_history_observations
      self.data["SocialHistory"]["Observations"]
    end

    def social_history_pregnancies
      self.data["SocialHistory"]["Pregnancy"]
    end

    def social_history_tobacco_use
      self.data["SocialHistory"]["TobaccoUse"]
    end

    def vital_signs
      self.data["VitalSigns"]
    end

    def has_allergies_data?
      !self.data["Allergies"].blank?
    end

    def has_encounters_data?
      !self.data["Encounters"].blank?
    end

    def has_family_history_data?
      !self.data["FamilyHistory"].blank?
    end

    def has_immunizations_data?
      !self.data["Immunizations"].blank?
    end

    def has_medical_equipment_data?
      !self.data["MedicalEquipment"].blank?
    end

    def has_medications_data?
      !self.data["Medications"].blank?
    end

    def has_plan_of_care_data?
      !self.data["PlanOfCare"].blank?
    end

    def has_problems_data?
      !self.data["Problems"].blank?
    end

    def has_procedures_data?
      !self.data["Procedures"]["Observations"].blank? && 
      !self.data["Procedures"]["Procedures"].blank? && 
      !self.data["Procedures"]["Services"].blank?
    end

    def has_results_data?
      !self.data["Results"].blank?
    end

    def has_social_history_data?
      !self.data["SocialHistory"].blank?
    end

    def has_vital_signs_data?
      !self.data["VitalSigns"].blank?
    end
  end
end
