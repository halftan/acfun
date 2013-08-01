require 'mongoid'
require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username,        type: String
  field :email,           type: String
  field :identity_number, type: String
  field :role,            type: String, default: :student
  field :password_hash,   type: String

  has_and_belongs_to_many :teaching_courses, class_name: "Course",
    inverse_of: :lecturers, autosave: true
  has_and_belongs_to_many :studying_courses, class_name: "Course",
    inverse_of: :students, autosave: true

  attr_protected :password_hash

  validates_presence_of     :email, message: "Email is required."
  validates_uniqueness_of   :email, message: "Email already in use."
  validates_format_of       :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
    message: "Please enter a valid email address"
  validates_presence_of     :role
  validates_inclusion_of    :role, in: %w(student teacher)
  validates_presence_of     :password_hash

  # default_scope without(:password_hash)

  def courses
    if role == "teacher"
      teaching_courses
    else
      studying_courses
    end
  end

  def course_ids
    if role == "teacher"
      teaching_course_ids
    else
      studying_course_ids
    end
  end

  def password=(password)
    bcry_pass = BCrypt::Password.create password
    self.password_hash = bcry_pass.to_s
  end

  def password
    BCrypt::Password.new self.password_hash
  end

  def self.authenticate email, passwd
    begin
      user = unscoped.find_by email: email
    rescue Mongoid::Errors::DocumentNotFound
      return nil
    end
    if user.password == passwd
      return user
    else
      return nil
    end
  end

end
