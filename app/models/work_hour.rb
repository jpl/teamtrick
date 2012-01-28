# Each WorkHour object represents hours that
# a certain User has been working on a certain Task.
class WorkHour < ActiveRecord::Base
  validates_presence_of :hours
  validates_presence_of :user
  validates_presence_of :task
  validates_presence_of :date
  validates_presence_of :old_hours_left

  belongs_to :user
  belongs_to :task

  scope :with_project, lambda{|p| {:joins => {:task => :story}, :conditions => ['stories.project_id = ?', p.is_a?(Integer) ? p : p.id]}}
  scope :with_task, lambda{|t| {:conditions => {:task_id => t.id}}}
  scope :by_date, :order => "date ASC"
  scope :with_date_between, lambda{|range| {:conditions => {:date => range}}}
  scope :before, lambda{|d| {:conditions => ['date < ?', d]}}
  scope :after, lambda{|d| {:conditions => ['date >= ?', d]}}

  attr_accessor :new_hours_left

  # Returns the Sprint during the WorkHours was done.
  def sprint
    Sprint.first(:conditions => "start_date < '#{date.to_time.to_s(:db)}' AND finish_date > '#{date.to_time.to_s(:db)}' AND project_id = '#{project.id}'") if project
  end

  # The Project of this WorkHour.
  def project
    story.project if story
  end

  # The Story of this WorkHour.
  def story
    task.story if task
  end

  # Sets Date.yesterday as default date.
  def after_initialize 
    return unless new_record?
    self.date ||= Date.yesterday
  end
end
