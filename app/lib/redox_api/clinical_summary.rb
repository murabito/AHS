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

    def family_history
      self.data["FamilyHistory"]
    end

    def medications
      self.data["Medications"]
    end

    def problems
      self.data["Problems"]
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

    def has_medications_data?
      !self.data["Medications"].blank?
    end

    def has_problems_data?
      !self.data["Problems"].blank?
    end
  end
end
