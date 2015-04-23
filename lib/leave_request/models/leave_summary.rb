class LeaveSummary
  attr_accessor :user_id, :name, :type, :left_last_year, :available_this_year, :taken_this_year, :left_this_year

  def initialize(user_id, name, type, left_last_year, available_this_year, taken_this_year, left_this_year)
    @user_id = user_id
    @name = name
    @type = type
    @left_last_year = left_last_year
    @available_this_year = available_this_year
    @taken_this_year = taken_this_year
    @left_this_year = left_this_year
  end
end