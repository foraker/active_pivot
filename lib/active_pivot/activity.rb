module ActivePivot
  class Activity
    attr_accessor :remote_activity

    def initialize(remote_activity)
      self.remote_activity = remote_activity
    end

    def store
      story.update_attribute(:started_at, updated_at) if store?
    end

    private

    def store?
      started? && started_before?(updated_at)
    end

    def started_before?(updated_at)
      story.started_at.nil? || story.started_at < updated_at
    end

    def story
      @story ||= ActivePivot::Story.find_by_pivotal_id(story_id)
    end

    def started?
      current_state.present? && current_state == 'started'
    end

    def kind
      @kind ||= primary_resource['kind']
    end

    def story_id
      @story_id ||= primary_resource['id']
    end

    def current_state
      new_values.present? ? new_values['current_state'] : 'unstarted'
    end

    def updated_at
      @updated_at ||= new_values['updated_at']
    end

    def primary_resource
      remote_activity.primary_resources[0]
    end

    def new_values
      remote_activity.changes[0]['new_values']
    end
  end
end
