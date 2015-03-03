require 'date_util'

class User < ActiveRecord::Base
  has_many :details, class_name: 'Detail'
  has_many :summaries, class_name: 'Summary'
  include Util::DateUtil

  # return the start and end working day of current user
  def start_and_end_working_day_of_the_year()
    if new_hires_of_the_year?
      return {"start_working_day"=>joined_date, "end_working_day"=>Date.today}
    else
      return {"start_working_day"=>first_day_of_the_year, "end_working_day"=>Date.today}
    end
  end

  def new_hires_of_the_year?()
    return first_day_of_the_year() <= joined_date
  end

end

