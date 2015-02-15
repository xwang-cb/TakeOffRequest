class Detail < ActiveRecord::Base
  # ActiveRecord::SubclassNotFound (Invalid single-table inheritance type...)
  # http://stackoverflow.com/questions/18243367/rails-invalid-single-inheritance
  self.inheritance_column = nil
end
