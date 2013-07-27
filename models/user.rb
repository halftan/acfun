#require 'mongoid'

class User
#  include Mongoid::Document
#
#  field :name, type: String
#  field :email, type: String
#  field :student_id, type: String

  def initialize name
    @name = name
  end

  def name
    @name
  end

  def putsnil
    puts "niilll"
    "niilll"
  end
end
