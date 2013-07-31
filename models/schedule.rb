require 'mongoid'

class Schedule
  include Mongoid::Document

  field :when,    type: Time
  field :where,   type: String
  field :what,    type: String, default: :lecture

  belongs_to :course

  def self.categories
    %w(lecture test examination practise experiment)
  end

  validates_inclusion_of :what, in: categories

end
