module ActivePivot
  class Story < ActiveRecord::Base
    self.table_name = "pivotal_stories"

    belongs_to :project, primary_key: :pivotal_id, foreign_key: :project_id

    has_many :time_entries, foreign_key: :project_number, primary_key: :pivotal_id
    has_many :project_types, through: :time_entries

    has_many :epic_stories
    has_many :epics, through: :epic_stories

    delegate :name, to: :project, prefix: true

    serialize :labels, Array

    def self.for_project(project_id)
      where(project_id: project_id)
    end

    def self.with_status(status)
      where(current_state: status)
    end

    def self.with_estimate(estimate)
      where(estimate: estimate)
    end

    def self.with_number(number)
      where(pivotal_id: number)
    end

    def self.order_by_project_name
      joins(:project).merge(Project.alphabetized)
    end

    def self.subselect(scope, attribute = :id)
      where("#{table_name}.id IN (#{scope.select(attribute).to_sql})")
    end

    def self.worked_on_before(date)
      subselect Story.unscoped.joins(:time_entries).merge(TimeEntry.worked_on_before(date))
    end

    def self.worked_on_after(date)
      subselect Story.unscoped.joins(:time_entries).merge(TimeEntry.worked_on_after(date))
    end

    def self.unique_statuses
      group(:current_state).pluck(:current_state)
    end

    def self.unique_estimates
      group(:estimate).pluck(:estimate).reject(&:blank?)
    end

    def self.select_all
      select("#{table_name}.*")
    end

    def self.accepted
      where.not(accepted_at: nil)
    end

    def self.accepted_after(date)
      where("#{table_name}.accepted_at >= ?", date)
    end

    def self.accepted_before(date)
      where("#{table_name}.accepted_at <= ?", date)
    end

    def self.select_points(as = :accepted_points)
      select("SUM(#{table_name}.estimate) as #{as}")
    end

    def self.with_tags(*tags)
      where("#{table_name}.tags @> ARRAY[?]", tags.join(","))
    end

    def labels=(labels)
      super(Array.wrap(labels))

      self.epics = extract_epics_for_labels(labels)
      self.tags  = extract_tags_for_labels(labels)
    end

    def state
      current_state
    end

    def human_state
      state.titleize
    end

    def human_type
      story_type.titleize
    end

    def hours
      read_attribute(:minutes) ? (minutes / 60.0) : time_entries.map(&:hours).sum
    end

    def invoice_hours
      read_attribute(:invoice_minutes) ? (invoice_minutes / 60.0) : time_entries.map(&:invoice_hours).sum
    end

    def billed_amount
      (read_attribute(:billed_amount) || time_entries.map(&:billed_amount).sum).to_f
    end

    def billed_amount_per_point
      estimate.to_i.zero? ? 0 : billed_amount / estimate.to_i
    end

    def hours_per_point
      estimate.to_i.zero? ? 0 : hours / estimate.to_i
    end

    def invoice_hours_per_point
      estimate.to_i.zero? ? 0 : invoice_hours / estimate.to_i
    end

    def to_param
      pivotal_id
    end

    def accepted?
      accepted_at?
    end

    private

    def extract_tags_for_labels(labels)
      Array.wrap(labels).reject(&:blank?).map { |label| label['name'] }
    end

    def extract_epics_for_labels(labels)
      label_ids = Array.wrap(labels).reject(&:blank?).map { |label| label['id'] }
      Epic.where.not(label_id: nil).where(label_id: label_ids)
    end
  end
end
