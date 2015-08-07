module ActivePivot
  class Epic < ActiveRecord::Base
    self.table_name = "pivotal_epics"

    has_many :epic_stories
    has_many :stories, through: :epic_stories
    has_many :time_entries, through: :stories
    belongs_to :project, primary_key: :pivotal_id,
      foreign_key: :pivotal_project_id
  end
end
