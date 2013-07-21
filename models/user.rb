require 'mongoid'

class User
  include Mongoid::Document

  field :name, type: String
  field :email, type: String
  field :student_id, type: String
end
