module ActivePivot
  module Generators
    class MigrationsGenerator < ::Rails::Generators::Base
      def create_all
        generate "migration", "create_pivotal_projects pivotal_id:integer name:text point_scale:text"
        generate "migration", "create_pivotal_epics project_id:integer:index pivotal_id:integer label_id:integer name:string url:string"
        generate "migration", "create_pivotal_stories pivotal_id:integer project_id:integer:index started_at:datetime accepted_at:datetime url:string estimate:integer name:text description:text kind:string story_type:string labels:text current_state:string tags:text[]"
        generate "migration", "create_pivotal_epic_stories story_id:integer:index epic_id:integer:index"
      end
    end
  end
end
