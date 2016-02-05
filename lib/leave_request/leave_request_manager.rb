require_relative '../../lib/leave_request/models/annual_statistic'

class LeaveRequestManager

  def left_leave_in_days(user, leave_type)
    time_period = user.start_and_end_working_day_of_the_year()

    if !AnnualStatistic.validate_time_period(time_period)
      raise "parameter error: start_working_day and end_working_day must in the same year"
    end

    current_year = AnnualStatistic.get_annual_statistic
    current_date = time_period["end_working_day"]

    year_preference = YearPreference.find_by_year(current_year)
    clean_day = year_preference.clean_date

    available_leave_in_hours = available_leave_in_hours(user, leave_type)
    left_leave_in_hours_last_year = left_leave_of_last_year(user, current_year, leave_type)

    if !YearPreference.pass_clean_day_of_the_year?(current_year, current_date)
      taken_leave_this_year = taken_leave(user, leave_type)

      left_leave_in_hours = (available_leave_in_hours + left_leave_in_hours_last_year) - taken_leave_this_year
    else
      taken_leave_before_clean_day_this_year = Detail.taken_leave_before_clean_day(user, leave_type, clean_day)
      taken_leave_after_clean_day_this_year = Detail.taken_leave_after_clean_day(user, leave_type, clean_day)

      if left_leave_in_hours_last_year > taken_leave_before_clean_day_this_year
        left_leave_in_hours = available_leave_in_hours - taken_leave_after_clean_day_this_year
      else
        left_leave_in_hours = available_leave_in_hours - (taken_leave_before_clean_day_this_year - left_leave_in_hours_last_year + taken_leave_after_clean_day_this_year)
      end
    end

    return (left_leave_in_hours / AnnualStatistic::LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR) #Return left leave in days
  end

  def left_leave_last_year_in_days(user, leave_type)
    return (user.summaries.where(:type=>leave_type, :year=>Time.now.year)[0].left_last_year / AnnualStatistic::LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR)
  end

  def taken_leave_in_days(user, leave_type)
    time_period = user.start_and_end_working_day_of_the_year()
    details = Detail.where(user_id: user.id, type: leave_type, start_time: (time_period["start_working_day"]..time_period["end_working_day"]))
    return details.sum('hours') / AnnualStatistic::LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR
  end

  def available_leave_in_days(user, leave_type)
    available_leave_in_hours(user, leave_type) / AnnualStatistic::LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR
  end

  def available_leave_in_hours(user, leave_type)
    time_period = user.start_and_end_working_day_of_the_year() # wxhtodo: 需要重构么
    annual_statistic = AnnualStatistic.new

    if leave_type == Summary.types[:annual]
      if user.old_staff_at_least_5_years?
        return AnnualStatistic::ANNUAL_LEAVE_IN_HOURS_FOR_A_MONTH_FOR_OLD_STAFF_AT_LEAST_5_YEARS * annual_statistic.num_of_available_closing_day(time_period)
      else
        return AnnualStatistic::ANNUAL_LEAVE_IN_HOURS_FOR_A_MONTH * annual_statistic.num_of_available_closing_day(time_period)
      end
    else
      return AnnualStatistic::MEDICAL_LEAVE_IN_HOURS_FOR_A_MONTH * annual_statistic.num_of_available_closing_day(time_period)
    end
  end



private


  def left_leave_of_last_year(user, year, leave_type)
    summary = user.summaries.find_by_year_and_type(year, leave_type)
    return summary.left_last_year
  end

  def taken_leave(user, leave_type)
    time_period = user.start_and_end_working_day_of_the_year()
    details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<=?", user.id, leave_type,
                            time_period["start_working_day"], time_period["end_working_day"]])
    return details.sum('hours')
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
