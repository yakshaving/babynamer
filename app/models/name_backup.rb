class Name
  include Mongoid::Document
  field :name, :type => String
  field :gender, :type => String
  field :meaning, :type => String
  field :origin, :type => String

end
