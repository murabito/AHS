module RedoxApi
  class Patient
    attr_reader :data

    def initialize(data={})
      @data = data
    end
  end
end