module RedoxApi::Core
  class RequestService

    BASE_URI = "https://api.redoxengine.com"
    API_KEY = ENV["REDOX_API_KEY"]
    SECRET = ENV["REDOX_SECRET"]
    FORMAT = :json

    def self.request(method, path, options = {})
      Response.new build_request(method, path, options).perform
    end

    def self.build_request(method, path, options = {})
      body = options.delete(:body) || ''
      headers = options.delete(:headers) || {}
      method = "Net::HTTP::#{method.to_s.downcase.titleize}".constantize
      request = HTTParty::Request.new( method, 
                                       path,
                                       base_uri: BASE_URI,
                                       body: body
                                      )
      request.options[:headers] = append_headers(headers, request, body) unless requires_no_header?(path)
      request
    end

    def self.append_headers(headers, request, body)
      token = access_token
      auth_header = { "Authorization" => "Bearer #{token}" }
      default_header = { 'Content-Type' => 'application/json' }
      auth_header.merge(default_header).merge(headers)
    end

    def self.authenticated_response
      body = { "apiKey" => API_KEY,
               "secret" => SECRET }
      
      authenticate_request = build_request('POST', '/auth/authenticate', body: body)
      Response.new authenticate_request.perform
    end

    def self.access_token
      response = authenticated_response

      response.data["accessToken"]
    end

    def self.patient_query(ssn)
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
            "SSN": ssn
          }
        }
      }

      body = body.to_json

      request("POST", "/query", body: body)
    end

    def self.requires_no_header?(path)
      !!(path == '/auth/authenticate')
    end

  end
end



