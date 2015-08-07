module ActivePivot
  module Api
    class Story < OpenStruct
      STATES = %w{ accepted delivered finished started rejected unstarted unscheduled }

      def self.default_filter
        Filter.new({
          state: STATES,
          includedone: true
        })
      end

      def self.for_project(project_id, params = {})
        collection(project_id, default_filter.merge(params).to_params).all
          .map { |story| self.new(story) rescue nil }
          .compact
      end

      def self.collection(project_id, params = {})
        PaginatedCollection.new("/services/v5/projects/#{project_id}/stories.json", params.as_json)
      end
    end
  end
end
