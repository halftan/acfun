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

  has_and_belongs_to_many :teaching_courses, class_name: "Course", inverse_of: :lecturers
  has_and_belongs_to_many :courses, inverse_of: :students

  attr_protected :password_hash

  validates_presence_of :email
  validates_presence_of :role
  validates_presence_of :password_hash

  def password=(password)
    bcry_pass = BCrypt::Password.create password
    self.password_hash = bcry_pass.to_s
  end

  def password
    BCrypt::Password.new self.password_hash
  end

end
