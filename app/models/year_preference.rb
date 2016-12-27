class YearPreference < ActiveRecord::Base

  def self.pass_clean_day_of_the_year?(year, date)
    if(!((date.month == 12) && (date.day > AnnualStatistic::CLOSING_DATE_OF_MONTH)) &&
        ((year.to_i) != date.year))
      raise "parameter error: year and date should like year=>2015, date=>'2015-03-01'"
    end

    preference = YearPreference.find_by_year(year)
    return (date >= preference.clean_date)
  end

end

