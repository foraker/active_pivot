module ActivePivot
  module Api
    class Config
      def self.api_token
        Rails.application.secrets['tracker_api_token']
      end
    end
  end
end
