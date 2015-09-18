# 统计年度
class AnnualStatistic

  # Every time when pass CLOSING_DATE_OF_MONTH we will add 1/12 holiday
  CLOSING_DATE_OF_MONTH = 15

  MAX_DAYS_OF_MEDICAL_LEAVE = 5.0
  MAX_DAYS_OF_ANNUAL_LEAVE = 10.0
  MAX_DAYS_OF_ANNUAL_LEAVE_FOR_OLD_STAFF_AT_LEAST_5_YEARS = 15.0

  MONTH_IN_A_YEAR = 12

  # 1 leave day convert to 8 leave hours
  LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR = 8.0

  ANNUAL_LEAVE_IN_HOURS_FOR_A_MONTH = (MAX_DAYS_OF_ANNUAL_LEAVE * LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR) / MONTH_IN_A_YEAR
  ANNUAL_LEAVE_IN_HOURS_FOR_A_MONTH_FOR_OLD_STAFF_AT_LEAST_5_YEARS = (MAX_DAYS_OF_ANNUAL_LEAVE_FOR_OLD_STAFF_AT_LEAST_5_YEARS * LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR) / MONTH_IN_A_YEAR
  MEDICAL_LEAVE_IN_HOURS_FOR_A_MONTH = (MAX_DAYS_OF_MEDICAL_LEAVE * LEAVE_CONVERSION_RATE_FROM_DAY_TO_HOUR) / MONTH_IN_A_YEAR

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
    return !AnnualStatistic.validate_time_period(time_period)
  end

  # return the latest closing date of current year based on the given start date
  def closing_day_based_on_the_start_day(start_day)
    if start_day > AnnualStatistic::last_closing_day_of_the_annual_statistic()
      return nil
    end

    if start_day.day < AnnualStatistic::CLOSING_DATE_OF_MONTH
      return closing_day_of_the_month(start_day)
    else
      return closing_day_of_next_month(start_day)
    end
  end

  def self.validate_time_period(time_period)
    start_working_day = time_period["start_working_day"]
    end_working_day = time_period["end_working_day"]

    if time_period_in_current_annual_statistic?(get_annual_statistic(), start_working_day, end_working_day)
      return true
    end

    return false
  end

  # 获取统计年度信息
  def self.get_annual_statistic()
    today = Date.today()

    if (today.mon == 12) && (today.day > AnnualStatistic::CLOSING_DATE_OF_MONTH)
      return today.year + 1
    end

    return today.year
  end

  # The year is from 12-16 of last year to 12-15 this year
  def self.first_closing_day_of_the_annual_statistic()
    return Date.new(get_annual_statistic() - 1, 12, AnnualStatistic::CLOSING_DATE_OF_MONTH + 1)
  end

  # 最后一个closing day of统计年度
  def self.last_closing_day_of_the_annual_statistic()
    return Date.new(get_annual_statistic(), 12, AnnualStatistic::CLOSING_DATE_OF_MONTH)
  end

private

  # 起始时间和结束时间在当前工作年度内
  def self.time_period_in_current_annual_statistic?(annual_statistic, start_working_day, end_working_day)
    (first_closing_day_of_the_annual_statistic() <= start_working_day) &&
        (end_working_day <= AnnualStatistic::last_closing_day_of_the_annual_statistic())
  end

  def self.start_working_day_in_last_year?(start_working_day)
    (start_working_day.mon = 12) && (start_working_day >= AnnualStatistic::CLOSING_DATE_OF_MONTH)
  end

  def closing_day_of_the_month(date)
    return Date.new(date.year, date.mon, AnnualStatistic::CLOSING_DATE_OF_MONTH)
  end

  def closing_day_of_next_month(date)
    return Date.new(date.year, date.mon, AnnualStatistic::CLOSING_DATE_OF_MONTH) >> 1
  end


end