class Detail < ActiveRecord::Base
  belongs_to :user

  # ActiveRecord::SubclassNotFound (Invalid single-table inheritance type...)
  # http://stackoverflow.com/questions/18243367/rails-invalid-single-inheritance
  self.inheritance_column = nil


  def self.taken_leave_before_clean_day(user_name, leave_type, year, clean_date)
    user = User.find_by_name(user_name)
    details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<?", user.id, leave_type, Date.new(year,1,1), clean_date])
    return details.sum('hours')
  end

  def self.taken_leave_after_clean_day(user_name, leave_type, year, clean_date)
    user = User.find_by_name(user_name)
    details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<?", user.id, leave_type, clean_date, Date.new(year+1,1,1)])
    return details.sum('hours')
  end

end
