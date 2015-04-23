require 'rails_helper'

require_relative '../../lib/take_off_request_manager'

describe Detail, type: :model do
  describe 'find method' do
    context 'when load jieyangs annual taken leave' do
      it "should return 33 hours" do
        user = User.find_by_name('Jie Yang')
        details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<?", user.id, Summary.types[:annual], Date.new(2015,1,1), Date.new(2016,1,1)])
        expect(details.sum('hours')).to eq(33)
      end
    end

    context 'when load jieyangs annual taken leave before the clean day' do
      it "should return 22 hours" do
        taken_leave = Detail.taken_leave_before_clean_day('Jie Yang', Summary.types[:annual], 2015, Date.new(2015,3,1))
        expect(taken_leave).to eq(22)
      end
    end

    context 'when load jieyangs annual taken leave after the clean day' do
      it "should return 11 hours" do
        taken_leave = Detail.taken_leave_after_clean_day('Jie Yang', Summary.types[:annual], 2015, Date.new(2015,3,1))
        expect(taken_leave).to eq(11)
      end
    end

    context 'when load jieyangs medical taken leave' do
      it "should return 20 hours" do
        user = User.find_by_name('Jie Yang')
        details = Detail.where(["user_id=? and type=? and start_time>=? and start_time<?", user.id, Summary.types[:medical], Date.new(2015,1,1), Date.new(2016,1,1)])
        expect(details.sum('hours')).to eq(20)
      end
    end

    context 'when load jieyangs medical taken leave before the clean day' do
      it "should return 20 hours" do
        taken_leave = Detail.taken_leave_before_clean_day('Jie Yang', Summary.types[:medical], 2015, Date.new(2015,3,1))
        expect(taken_leave).to eq(20)
      end
    end

    context 'when load jieyangs medical taken leave after the clean day' do
      it "should return 26 hours" do
        taken_leave = Detail.taken_leave_after_clean_day('Jie Yang', Summary.types[:medical], 2015, Date.new(2015,3,1))
        expect(taken_leave).to eq(0)
      end
    end
  end



  describe 'test' do
    context 'all' do

      users = User.all
      manager = LeaveRequestManager.new
      time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 15)}

      users.each do |user|
        left_annual_leave = manager.left_leave_in_days(user.name, time_period, Summary.types[:annual]).round(1)
        left_medical_leave = manager.left_leave_in_days(user.name, time_period, Summary.types[:medical]).round(1)
        taken_annual_leave = manager.taken_leave_in_days(user.name, time_period, Summary.types[:annual]).round(1)
        taken_medical_leave = manager.taken_leave_in_days(user.name, time_period, Summary.types[:medical]).round(1)
        puts  %Q{#{user.name}:\t 剩余#{left_annual_leave}天年假 \t#{left_medical_leave}天病假, 已请#{taken_annual_leave}天年假\t#{taken_medical_leave}天病假}
      end
    end
  end
end
