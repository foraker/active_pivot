module ActivePivot
  module Api
    class Project < OpenStruct
      COLLECTION_URL = "/services/v5/projects.json?fields=:default,current_velocity,current_volatility"

      def self.all
        Api::PaginatedCollection.new(COLLECTION_URL).all.map do |remote_project|
          self.new(remote_project)
        end
      end
    end
  end
end
