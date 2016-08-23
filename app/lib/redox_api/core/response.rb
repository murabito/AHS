module RedoxApi::Core
  class Response
    attr_reader :response
    attr_reader :status
    attr_reader :data
    attr_reader :errors
    attr_reader :headers

    def initialize(response)
      @response = response
      @status = response.code
      @headers = response.headers
      if is_success?
        if response.content_type == "application/json"
          @data = JSON.parse(response.body) unless response.body.blank?
        else
          @data = response.body
        end
      else
        begin
          @errors = JSON.parse(response.body)
        rescue JSON::ParserError
          @data = response.body
        end
      end
    end

    def is_success?
      @status >= 200 && @status < 300
    end
  end
end
