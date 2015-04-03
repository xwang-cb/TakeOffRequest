class Summary < ActiveRecord::Base
  belongs_to :user

  self.inheritance_column = nil

  enum type: [ :annual, :medical ]

end
