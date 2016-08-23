module RedoxApi::Core
  class RequestService

    BASE_URI = "https://api.redoxengine.com"
    API_KEY = ENV["REDOX_API_KEY"]
    SECRET = ENV["REDOX_SECRET"]
    FORMAT = :json

    def self.authenticate
      body = { "apiKey" => API_KEY,
               "secret" => SECRET }
      method = "POST"
      method = "Net::HTTP::#{method.to_s.downcase.titleize}".constantize
      path = '/auth/authenticate'
      request = HTTParty::Request.new( method, path,
                                        base_uri: BASE_URI,
                                        body: body
                                        )
      
      response = request.perform
    end

    def self.access_token(response)
      response_data = JSON.parse(response.body)
      response_data["accessToken"]
    end

    def self.patient_query(ssn)
      response = RedoxApi::Core::RequestService.authenticate
      token = RedoxApi::Core::RequestService.access_token(response)
      
      headers = { 'Authorization' => "Bearer #{token}",
                  "Content-Type" => "application/json" }

      body = {
        "Meta": {
          "DataModel": "PatientSearch",
          "EventType": "Query",
          "Destinations": [
            {
              "ID": "0f4bd1d1-451d-4351-8cfd-b767d1b488d6",
              "Name": "Patient Search Endpoint"
            }
          ]
        },
        "Patient": {
          "Demographics": {
            "FirstName": "Timothy",
            "LastName": "Bixby",
            "DOB": "2008-01-06",
            "SSN": ssn,
            "PhoneNumber": {
              "Home": "+18088675301",
            },
            "Address": {
              "StreetAddress": "4762 Hickory Street",
              "City": "Monroe",
              "State": "WI",
              "ZIP": "53566",
              "County": "Green",
              "Country": "US"
            }
          },
        }
      }

      body = body.to_json
      method = "POST"
      method = "Net::HTTP::#{method.to_s.downcase.titleize}".constantize
      path = '/query'
      request = HTTParty::Request.new( method, path,
                                        base_uri: BASE_URI,
                                        headers: headers,
                                        body: body
                                        )
      
      response = request.perform
    end

  end
end



