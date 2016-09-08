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

    def allergies
      self.data["Allergies"]
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
