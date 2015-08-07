module ActivePivot
  class EpicStory < ActiveRecord::Base
    self.table_name = :pivotal_epic_stories

    belongs_to :story
    belongs_to :epic
  end
end
