class YearPreference < ActiveRecord::Base

  def self.pass_clean_day_of_the_year?(year, date)
    if((year.to_i + 1) != date.year)
      raise "parameter error: year and date should like year=>2014, date=>'2015-02-28'"
    end

    preference = YearPreference.find_by_year(year)
    return (date > preference.clean_date)
  end

end

