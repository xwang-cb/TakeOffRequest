require_relative '../../lib/leave_request/leave_request_manager'
require_relative '../../lib/leave_request/models/leave_summary'

class SummariesController < ApplicationController
  before_filter :admin_authorize, only: [:index]

  def index
    @annual_leave_summaries = get_all_leave_summaries(Summary.types[:annual])
    @medical_leave_summaries = get_all_leave_summaries(Summary.types[:medical])
  end

  def index_of_an_user
    @user = User.find(params[:user_id])
    @annual_leave_summary = get_leave_summary(@user, Summary.types[:annual])
    @medical_leave_summary = get_leave_summary(@user, Summary.types[:medical])
    @details = Detail.where(user_id: params[:user_id]).order(:start_time).reverse_order
  end

private

  def get_all_leave_summaries(leave_type)
    users = User.where("name <> 'Admin'")
    leave_summaries = []
    users.each do |user|
      leave_summaries << get_leave_summary(user, leave_type)
    end
    return leave_summaries
  end

  def get_leave_summary(user, leave_type)
    manager = LeaveRequestManager.new
    return LeaveSummary.new(user, leave_type,
                            manager.left_leave_last_year_in_days(user, leave_type).round(1),
                            manager.available_leave_in_days(user, leave_type).round(1),
                            manager.taken_leave_in_days(user, leave_type).round(1),
                            manager.left_leave_in_days(user, leave_type).round(1)
    )
  end

end
