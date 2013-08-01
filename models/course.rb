require 'mongoid'

class Course
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          type: String
  field :is_completed,  type: Boolean, default: false

  has_and_belongs_to_many :lecturers, class_name: "User", inverse_of: :teaching_courses
  has_and_belongs_to_many :students, class_name: "User"
  has_many                :schedules, autosave: true

  # Dynamically defines scopes for each category,
  # which defined as Schedule::categories.
  Schedule.categories.each do |category|
    define_method category.to_s.pluralize do
      schedules.where(what: category)
    end
  end

  validates_presence_of :name

  accepts_nested_attributes_for :schedules

  # Public: Mark a course completed
  #
  # Returns the save state. true means success
  def complete!
    self.is_completed = true
    self.save
  end

  # Public: whether a course is marked completed
  #
  # Returns the state, true means completed.
  def completed?
    self.is_completed
  end

  # Public: Search for schedules that was already overdued
  #
  # Returns the Mongoid::Criteria
  def overdue
    schedules.where(:when.lte => Time.now)
  end

  # Public: Search for schedules that will soon overdue
  #
  # range - The overdue time, must be UTC int (Default: 4.days)
  #
  # Returns the Mongoid::Criteria
  def soon range=4.days
    schedules.where(:when.lte => range.from_now)
  end

  # Public: Search for schedules that will not due so soon
  #
  # range - The overdue time, must be UTC int (Default: 7.days)
  #
  # Returns the Mongoid::Criteria
  def future from=7.days
    schedules.where(:when.gte => from.from_now)
  end
end
