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

    def has_allergies_data?
      !self.data["Allergies"].blank?
    end

    def has_encounters_data?
      !self.data["Encounters"].blank?
    end

    def has_family_history_data?
      !self.data["FamilyHistory"].blank?
    end
  end
end
