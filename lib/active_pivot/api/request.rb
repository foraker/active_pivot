module ActivePivot
  module Api
    class Request
      HOST = "https://www.pivotaltracker.com"

      attr_accessor :path, :params

      def self.get(path, params = {})
        self.new(path, params).get
      end

      def initialize(path, params = {})
        @path   = path
        @params = params
      end

      def get
        Response.new(HTTParty.get(HOST + path, options))
      end

      private

      def options
        {
          headers: {"X-TrackerToken" => api_token},
          query: params
        }
      end

      def api_token
        Api::Config.api_token
      end
    end
  end
end
