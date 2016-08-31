module RedoxApi
  class Patient
    attr_reader :data
    attr_reader :id

    def initialize(data={})
      @data = data
      @id = patient_id
    end

    def patient_id
      identifiers = @data["Identifiers"]

      nist_id = ''
      identifiers.each do |identifier|
        nist_id = identifier["ID"] if identifier["IDType"] == 'NIST'
      end
      nist_id
    end

    def last_name
      self.data["Demographics"]["LastName"].titlecase
    end

    def first_name
      self.data["Demographics"]["FirstName"].titlecase
    end

    def dob
      Date.new(self.data["Demographics"]["DOB"].to_d)
    end
  end
end