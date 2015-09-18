
module Util

  module DateUtil

    def first_day_of_the_year()
      return Date.new(Date.today.year, 1, 1)
    end



  end

end

# class C
#   include Util::DateUtil
# end
#
# p C.new.first_day_of_the_year