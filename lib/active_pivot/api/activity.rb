module ActivePivot
  module Api
    class Activity < OpenStruct
      STATES = %w{ accepted delivered finished started rejected unstarted unscheduled }

      def self.default_filter
        Filter.new({
          # state: STATES,
          # includedone: true
        })
      end

      def self.for_project(project_id, story_id, params = {})
        collection(project_id, story_id).all
          .map { |story| self.new(story) rescue nil }
          .compact
      end

      def self.collection(project_id, story_id, params = {})
        PaginatedCollection.new("/services/v5/projects/#{project_id}/stories/#{story_id}/activity.json")
      end
    end
  end
end
