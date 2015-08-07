module ActivePivot
  module Api
    class Epic < OpenStruct
      def self.for_project(project_id, params = {})
        collection(project_id, params).all
          .reject { |response| response["kind"] == "error" }
          .map { |epic| self.new(epic) rescue nil }
          .compact
      end

      def self.collection(project_id, params = {})
        PaginatedCollection.new("/services/v5/projects/#{project_id}/epics.json", params.as_json)
      end
    end
  end
end
