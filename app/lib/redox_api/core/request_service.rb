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

  end
end



