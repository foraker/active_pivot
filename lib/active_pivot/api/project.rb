module ActivePivot
  module Api
    class Project < OpenStruct
      def self.all
        Api::PaginatedCollection.new("/services/v5/projects.json?fields=:default,current_velocity,current_volatility").all.map do |remote_project|
          self.new(remote_project) rescue nil
        end.compact
      end
    end
  end
end
