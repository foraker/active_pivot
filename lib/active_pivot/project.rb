module ActivePivot
  class Project < ActiveRecord::Base
    self.table_name = "pivotal_projects"

    has_many :stories, primary_key: :pivotal_id, foreign_key: :project_id
    has_many :epics, primary_key: :pivotal_id, foreign_key: :pivotal_project_id

    def self.alphabetized
      order("lower(#{table_name}.name)")
    end

    def remote_stories(params = {})
      Api::Story.for_project(pivotal_id, params)
    end

    def remote_epics(params = {})
      Api::Epic.for_project(pivotal_id, params)
    end
  end
end
