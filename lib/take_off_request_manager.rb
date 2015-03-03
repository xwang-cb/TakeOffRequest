
class TakeOffRequestManager

  MAX_DAYS_OF_MEDICAL_LEAVE = 5
  MAX_DAYS_OF_ANNUAL_LEAVE = 10

  # Every time when pass CLOSING_DATE_OF_MONTH we will add 1/12 holiday
  CLOSING_DATE_OF_MONTH = 15

  def num_of_left_annual_leave(user_name, start_and_end_working_day_of_the_year)
    if !validate_start_and_end_working_day_of_the_year(start_and_end_working_day_of_the_year)
      raise "parameter error: start_working_day and end_working_day must in the same year"
    end

    current_year = year(start_and_end_working_day_of_the_year)
    current_date = start_and_end_working_day_of_the_year["end_working_day"]

    # 1. 获取今年到目前为止可用的年假数

    if !YearPreference.pass_clean_day_of_the_year?(current_year, current_date)
      # 2. 获取去年剩余的年假数
      # 3. 获取今年已用的年假数
      # 剩余年假 = (1+2)-3

    else
      # 4. 获取今年clean_day前已用的年假数
      # 5. 如果("去年剩余的年假数">4)，则"今年已用的年假数"="clean_day后用的年假数"；
      #    否则"今年已用的年假数"=4-"去年剩余的年假数"+"clean_day后用的年假数"

    end

  end

  def num_of_available_annual_leave(start_and_end_working_day_of_the_year)
    return MAX_DAYS_OF_ANNUAL_LEAVE / num_of_available_closing_day(start_and_end_working_day_of_the_year)
  end

  def num_of_available_medical_leave(start_and_end_working_day_of_the_year)
    return MAX_DAYS_OF_MEDICAL_LEAVE / num_of_available_closing_day(start_and_end_working_day_of_the_year)
  end

  def num_of_available_closing_day(start_and_end_working_day_of_the_year)
    start_working_day = start_and_end_working_day_of_the_year["start_working_day"]
    end_working_day = start_and_end_working_day_of_the_year["end_working_day"]

    if has_no_available_closing_day?(start_and_end_working_day_of_the_year)
      return 0
    end

    result = 0
    closing_day = closing_day_based_on_the_start_day(start_working_day)
    while closing_day <= end_working_day
      result += 1
      closing_day = closing_day.next_month
    end

    return result
  end

  def has_no_available_closing_day?(start_and_end_working_day_of_the_year)
    start_working_day = start_and_end_working_day_of_the_year["start_working_day"]
    end_working_day = start_and_end_working_day_of_the_year["end_working_day"]

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

  def validate_start_and_end_working_day_of_the_year(start_and_end_working_day_of_the_year)
    start_working_day = start_and_end_working_day_of_the_year["start_working_day"]
    end_working_day = start_and_end_working_day_of_the_year["end_working_day"]

    if start_working_day.year != end_working_day.year
      return false
    end

    return true
  end

  def year(start_and_end_working_day_of_the_year)
    start_working_day = start_and_end_working_day_of_the_year["start_working_day"]

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

# manager = TakeOffRequestManager.new
# # p Date.new(2015,1,14).prev_month
# # p manager.closing_date_based_on_the_start_date(Date.new(2015,1,13)).strftime("%Y-%m-%d")
# # p manager.first_closing_day_of_the_year(2025)
#
# p manager.num_of_available_closing_day({"start_working_day"=>Date.new(2015,2,1),
#                                         "end_working_day"=>Date.new(2015,3,15)})
