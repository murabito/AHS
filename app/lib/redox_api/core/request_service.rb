module RedoxApi::Core
  class RequestService

    BASE_URI = "https://api.redoxengine.com"
    API_KEY = ENV["REDOX_API_KEY"]
    SECRET = ENV["REDOX_SECRET"]
    FORMAT = :json

    def self.request
      response = authenticate
      token = access_token(response)
      response = Response.new patient_query(token, "101-01-0001")
    end

    def self.build_request(method, path, options = {})
      body = options.delete(:body) || ''
      method = "Net::HTTP::#{method.to_s.downcase.titleize}".constantize
      request = HTTParty::Request.new( method, 
                                       path,
                                       base_uri: BASE_URI,
                                       body: body
                                      )
      
      response = request.perform
    end

    def self.authenticated_response
      body = { "apiKey" => API_KEY,
               "secret" => SECRET }
      
      response = Response.new build_request('POST', '/auth/authenticate', body: body)
    end

    def self.access_token
      response = authenticated_response

      response.data["accessToken"]
    end

    def self.patient_query(token, ssn)
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
            "SSN": ssn
          }
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

    def is_success?
      @status >= 200 && @status < 300
    end

  end
end



