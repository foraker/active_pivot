module ActivePivot
  class Importer < Struct.new(:params)
    def self.run(updated_after = 5.minutes.ago)
      self.new({updated_after: updated_after}).run
    end

    def run
      puts "Importing Projects"
      import_projects
      puts "Importing Epics"
      import_epics
      puts "Importing Stories"
      import_stories
      puts "Importing Activity - may take up to 10 minutes"
      import_activities
    end

    private

    def import_projects
      Api::Project.all.each do |remote_project|
        ActivePivot::Project.where(pivotal_id: remote_project.id)
          .first_or_initialize
          .update_attributes!({
            name:               remote_project.name,
            point_scale:        remote_project.point_scale,
            current_velocity:   remote_project.current_velocity,
            current_volatility: remote_project.current_volatility
          })
      end
    end

    def import_epics
      ActivePivot::Project.all.each do |project|
        project.remote_epics(params.except(:updated_after)).each do |remote_epic|
          import_epic(remote_epic)
        end
      end
    end

    def import_stories
      Project.all.each do |project|
        project.remote_stories(params).each do |remote_story|
          import_story(remote_story)
        end
      end
    end

    def import_activities
      Story.all.each do |story|
        story.remote_activities(params).each do |remote_activity|
          import_activity(remote_activity)
        end
      end
    end

    def import_epic(remote_epic)
      ActivePivot::Epic.where(pivotal_id: remote_epic.id.to_s)
        .first_or_initialize
        .update_attributes({
          project_id: remote_epic.project_id,
          name:       remote_epic.name,
          url:        remote_epic.url,
          label_id:   remote_epic.label.try(:[], "id")
        })
    end

    def import_story(remote_story)
      ActivePivot::Story.where(pivotal_id: remote_story.id.to_s)
        .first_or_initialize
        .update_attributes!({
          project_id:    remote_story.project_id,
          pivotal_id:    remote_story.id,
          name:          remote_story.name,
          description:   remote_story.description,
          kind:          remote_story.kind,
          story_type:    remote_story.story_type,
          labels:        remote_story.labels,
          current_state: remote_story.current_state,
          estimate:      remote_story.estimate,
          accepted_at:   remote_story.accepted_at,
          url:           remote_story.url
        })
    end

    def import_activity(remote_activity)
      ActivePivot::Activity.new(remote_activity).store
    end
  end
end
