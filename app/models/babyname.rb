class Babyname
  include Mongoid::Document
  field :name, type: String
  field :category, type: String
  field :origin, type: String
  field :meaning, type: String
  field :gender, type: String

  validates_presence_of :name, :gender
  validates_uniqueness_of :name, :scope => :gender

  # index({name: 1}, {unique: true, name: "name_index"})
end
