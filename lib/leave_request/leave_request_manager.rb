
class LeaveRequestManager

  MAX_DAYS_OF_MEDICAL_LEAVE = 5.0
  MAX_DAYS_OF_ANNUAL_LEAVE = 10.0

  # 1 leave day convert to 8 leave hours
  LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR = 8.0

  MONTH_IN_A_YEAR = 12

  ANNUAL_LEAVE_IN_HOURS_FOR_A_MONTH = (MAX_DAYS_OF_ANNUAL_LEAVE * LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR) / MONTH_IN_A_YEAR
  MEDICAL_LEAVE_IN_HOURS_FOR_A_MONTH = (MAX_DAYS_OF_MEDICAL_LEAVE * LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR) / MONTH_IN_A_YEAR

  # Every time when pass CLOSING_DATE_OF_MONTH we will add 1/12 holiday
  CLOSING_DATE_OF_MONTH = 15

  def left_leave_in_days(user_name, time_period, leave_type)
    if !validate_time_period(time_period)
      raise "parameter error: start_working_day and end_working_day must in the same year"
    end

    current_year = year(time_period)
    current_date = time_period["end_working_day"]

    year_preference = YearPreference.find_by_year(current_year)
    clean_day = year_preference.clean_date

    available_leave_in_hours = available_leave_in_hours(time_period, leave_type)
    left_leave_in_hours_last_year = left_leave_of_last_year(user_name, current_year, leave_type)

    if !YearPreference.pass_clean_day_of_the_year?(current_year, current_date)
      taken_leave_this_year = taken_leave(user_name, time_period, leave_type)

      left_leave_in_hours = (available_leave_in_hours + left_leave_in_hours_last_year) - taken_leave_this_year
    else
      taken_leave_before_clean_day_this_year = Detail.taken_leave_before_clean_day(user_name, leave_type, current_year, clean_day)
      taken_leave_after_clean_day_this_year = Detail.taken_leave_after_clean_day(user_name, leave_type, current_year, clean_day)

      if left_leave_in_hours_last_year > taken_leave_before_clean_day_this_year
        left_leave_in_hours = available_leave_in_hours - taken_leave_after_clean_day_this_year
      else
        left_leave_in_hours = available_leave_in_hours - (taken_leave_before_clean_day_this_year - left_leave_in_hours_last_year + taken_leave_after_clean_day_this_year)
      end
    end

    return (left_leave_in_hours / LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR) #Return left leave in days
  end

  def left_leave_last_year_in_days(user_name, leave_type)
    user = User.find_by_name(user_name)
    return (user.summaries.where(:type=>leave_type)[0].left_last_year / LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR)
  end

  def taken_leave_in_days(user_name, time_period, leave_type)
    user = User.find_by_name(user_name)
    details = Detail.where(user_id: user.id, type: leave_type, start_time: (time_period["start_working_day"]..time_period["end_working_day"]))
    return details.sum('hours') / LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR
  end

  def available_leave_in_days(time_period, leave_type)
    available_leave_in_hours(time_period, leave_type) / LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR
  end

  def available_leave_in_hours(time_period, leave_type)
    if leave_type == Summary.types[:annual]
      return ANNUAL_LEAVE_IN_HOURS_FOR_A_MONTH * num_of_available_closing_day(time_period)
    else
      return MEDICAL_LEAVE_IN_HOURS_FOR_A_MONTH * num_of_available_closing_day(time_period)
    end
  end

  def num_of_available_closing_day(time_period)
    if has_no_available_closing_day?(time_period)
      return 0
    end

    result = 0
    closing_day = closing_day_based_on_the_start_day(time_period["start_working_day"])
    while closing_day <= time_period["end_working_day"]
      result += 1
      closing_day = closing_day.next_month
    end

    return result
  end

  def has_no_available_closing_day?(time_period)
    start_working_day = time_period["start_working_day"]
    end_working_day = time_period["end_working_day"]

    return ((end_working_day < first_closing_day_of_the_year(start_working_day)) ||
        (start_working_day > last_closing_day_of_the_year(start_working_day)))
  end

  # return the latest closing date of current year based on the given start date
  def closing_day_based_on_the_start_day(start_day)
    if start_day > last_closing_day_of_the_year(start_day)
      return nil
    end

    if start_day.day < CLOSING_DATE_OF_MONTH
      return closing_day_of_the_month(start_day)
    else
      return closing_day_of_next_month(start_day)
    end
  end


private


  def left_leave_of_last_year(user_name, year, leave_type)
    user = User.find_by_name(user_name)
    summary = user.summaries.find_by_year_and_type(year, leave_type)
    return summary.left_last_year
  end

  def taken_leave(user_name, time_period, leave_type)
    user = User.find_by_name(user_name)
    details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<?", user.id, leave_type,
                            time_period["start_working_day"], time_period["end_working_day"]])
    return details.sum('hours')
  end

  def validate_time_period(time_period)
    start_working_day = time_period["start_working_day"]
    end_working_day = time_period["end_working_day"]

    if start_working_day.year != end_working_day.year
      return false
    end

    return true
  end

  def year(time_period)
    start_working_day = time_period["start_working_day"]

    return start_working_day.year
  end

  def first_closing_day_of_the_year(date)
    return Date.new(date.year, 1, CLOSING_DATE_OF_MONTH)
  end

  def last_closing_day_of_the_year(date)
    return Date.new(date.year, 12, CLOSING_DATE_OF_MONTH)
  end

  def closing_day_of_the_month(date)
    return Date.new(date.year, date.month, CLOSING_DATE_OF_MONTH)
  end

  def closing_day_of_next_month(date)
    return Date.new(date.year, date.month+1, CLOSING_DATE_OF_MONTH)
  end

  # How many days have you worked to this day
  def working_days_in_the_year_to_this_day(start_date)
    return Date.today - start_date
  end

end


# manager = LeaveRequestManager.new
# time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 1)}
# p manager.num_of_left_leave("Ken Wang", time_period, Summary.types[:annual])

# # p Date.new(2015,1,14).prev_month
# # p manager.closing_date_based_on_the_start_date(Date.new(2015,1,13)).strftime("%Y-%m-%d")
# # p manager.first_closing_day_of_the_year(2025)
#
# p manager.num_of_available_closing_day({"start_working_day"=>Date.new(2015,2,1),
#                                         "end_working_day"=>Date.new(2015,3,15)})
