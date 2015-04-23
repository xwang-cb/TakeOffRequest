require_relative '../../lib/leave_request/leave_request_manager'
require_relative '../../lib/leave_request/models/leave_summary'

class SummariesController < ApplicationController

  def index
    time_period = {"start_working_day"=>Date.new(Date.today.year, 1, 1), "end_working_day"=>Date.today}

    @annual_leave_summaries = get_all_leave_summaries(Summary.types[:annual], time_period)
    @medical_leave_summaries = get_all_leave_summaries(Summary.types[:medical], time_period)
  end

private

  def get_all_leave_summaries(leave_type, time_period)
    users = User.all
    manager = LeaveRequestManager.new

    leave_summaries = []
    users.each do |user|

      leave_summary = LeaveSummary.new(user.id, user.name, leave_type,
                                       manager.left_leave_last_year_in_days(user.name, leave_type).round(1),
                                       manager.available_leave_in_days(time_period, leave_type).round(1),
                                       manager.taken_leave_in_days(user.name, time_period, leave_type).round(1),
                                       manager.left_leave_in_days(user.name, time_period, leave_type).round(1)
      )
      leave_summaries << leave_summary
    end
    return leave_summaries
  end

end
