module RedoxApi
  class Patient
    attr_reader :data
    attr_reader :id

    def initialize(data={})
      @data = data
      @id = patient_ids
    end

    def patient_ids
      @data["Identifiers"]
    end

    def patient_id(destination)
      mrn = ''
      patient_ids.each do | identifier |
        mrn = identifier["ID"] if identifier["IDType"] == destination.mrn_type
      end
      mrn 
    end
    
    def last_name
      self.data["Demographics"]["LastName"].titlecase
    end

    def first_name
      self.data["Demographics"]["FirstName"].titlecase
    end

    def dob
      Date.strptime(self.data["Demographics"]["DOB"], '%Y-%m-%d')
    end

    def ssn
      self.data["Demographics"]["SSN"]
    end
  end
end
