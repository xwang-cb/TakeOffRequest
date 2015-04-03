require 'rails_helper'

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
end
