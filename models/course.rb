require 'mongoid'

class Course
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          type: String
  field :is_completed,  type: Boolean, default: false

  has_and_belongs_to_many :lecturers, class_name: "User", inverse_of: :teaching_courses
  has_and_belongs_to_many :students, class_name: "User"

  validates_presence_of :name
end
