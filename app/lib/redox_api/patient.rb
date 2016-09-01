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
      Date.strptime(self.data["Demographics"]["DOB"], '%Y-%m-%d')
    end

    def ssn
      self.data["Demographics"]["SSN"]
    end

    def sex
      self.data["Demographics"]["Sex"]
    end

    def street_address
      self.data["Demographics"]["Address"]["StreetAddress"]
    end

    def city
      self.data["Demographics"]["Address"]["City"]
    end

    def state
      self.data["Demographics"]["Address"]["State"]
    end

    def county
      self.data["Demographics"]["Address"]["County"]
    end

    def country
      self.data["Demographics"]["Address"]["Country"]
    end

    def zip
      self.data["Demographics"]["Address"]["ZIP"]
    end

    def home_phone
      self.data["Demographics"]["PhoneNumber"]["Home"]
    end

    def mobile_phone
      self.data["Demographics"]["PhoneNumber"]["Mobile"]
    end

    def email
      email_array = self.data["Demographics"]["EmailAddresses"]
      email_list = email_array.first["Address"]

      if email_array.count > 1
        email_array.each { | address | email_list = email_list + ', ' + address["Address"] }
      end

      email_list
    end

    def race
      self.data["Demographics"]["Race"]
    end

    def ethnicity
      self.data["Demographics"]["Ethnicity"]
    end

    def marital_status
      self.data["Demographics"]["MaritalStatus"]
    end
  end
end
