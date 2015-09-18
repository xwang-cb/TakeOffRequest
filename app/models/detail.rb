class Detail < ActiveRecord::Base
  belongs_to :user

  # ActiveRecord::SubclassNotFound (Invalid single-table inheritance type...)
  # http://stackoverflow.com/questions/18243367/rails-invalid-single-inheritance
  self.inheritance_column = nil


  def self.taken_leave_before_clean_day(user, leave_type, clean_date)
    details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<?", user.id, leave_type,
                            AnnualStatistic.first_closing_day_of_the_annual_statistic(), clean_date])
    return details.sum('hours')
  end

  def self.taken_leave_after_clean_day(user, leave_type, clean_date)
    details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<?", user.id, leave_type,
                            clean_date, AnnualStatistic.last_closing_day_of_the_annual_statistic()])
    return details.sum('hours')
  end

end
