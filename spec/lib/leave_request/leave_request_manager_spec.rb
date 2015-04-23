require 'take_off_request_manager'

describe LeaveRequestManager do

  describe 'closing_day_based_on_the_start_day' do
    before do
      @manager = LeaveRequestManager.new
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return nil' do
        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 12, 16))
        expect(result).to eq(nil)
      end
    end

    context 'when start day is before the closing day of the month' do
      it 'should return the closing day of the month' do
        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 1, 1))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(1)
        expect(result.day).to eq(LeaveRequestManager::CLOSING_DATE_OF_MONTH)

        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 3, 11))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(3)
        expect(result.day).to eq(LeaveRequestManager::CLOSING_DATE_OF_MONTH)
      end
    end

    context 'when start day is after the closing day of the month' do
      it 'should return the closing day of next month' do
        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 3, 16))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(4)
        expect(result.day).to eq(LeaveRequestManager::CLOSING_DATE_OF_MONTH)

        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 3, 31))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(4)
        expect(result.day).to eq(LeaveRequestManager::CLOSING_DATE_OF_MONTH)
      end
    end

  end

  describe 'has_no_available_closing_day?' do
    before do
      @manager = LeaveRequestManager.new
    end

    context 'when end day is before the first closing day of the year' do
      it 'should return true' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 2), "end_working_day"=>Date.new(2015, 1, 14)}
        expect(@manager.has_no_available_closing_day?(time_period)).to eq(true)
      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return true' do
        time_period = {"start_working_day"=>Date.new(2015, 12, 16), "end_working_day"=>Date.new(2015, 12, 24)}
        expect(@manager.has_no_available_closing_day?(time_period)).to eq(true)
      end
    end

    context 'when start day and end day are between the first closing day and the last closing day of the year' do
      it 'should return false' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 16), "end_working_day"=>Date.new(2015, 12, 14)}
        expect(@manager.has_no_available_closing_day?(time_period)).to eq(false)
      end
    end
  end

  describe 'num_of_available_closing_day' do
    before do
      @manager = LeaveRequestManager.new
    end

    context 'when end day is before the first closing day of the year' do
      it 'should return 0' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 1, 14)}
        expect(@manager.num_of_available_closing_day(time_period)).to eq(0)
      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return 0' do
        time_period = {"start_working_day"=>Date.new(2015, 12, 16), "end_working_day"=>Date.new(2015, 12, 24)}
        expect(@manager.num_of_available_closing_day(time_period)).to eq(0)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-4-23' do
      it 'should return 4' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 23)}
        expect(@manager.num_of_available_closing_day(time_period)).to eq(4)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-4-14' do
      it 'should return 4' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 14)}
        expect(@manager.num_of_available_closing_day(time_period)).to eq(3)
      end
    end
  end

  describe 'num_of_available_leave' do
    before do
      @manager = LeaveRequestManager.new
    end

    context 'when end day is before the first closing day of the year' do
      it 'should return 0' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 1, 14)}
        expect(@manager.available_leave_in_hours(time_period, Summary.types[:annual])).to eq(0)
      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return 0' do
        time_period = {"start_working_day"=>Date.new(2015, 12, 16), "end_working_day"=>Date.new(2015, 12, 24)}
        expect(@manager.available_leave_in_hours(time_period, Summary.types[:annual])).to eq(0)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-4-23' do
      it 'should return 3.33' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 23)}
        expect(@manager.available_leave_in_hours(time_period, Summary.types[:annual]).round(2)).to eq(26.67)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-4-14' do
      it 'should return 4' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 14)}
        expect(@manager.available_leave_in_hours(time_period, Summary.types[:annual])).to eq(20)
      end
    end
  end

  describe 'num_of_left_leave' do
    before do
      @manager = LeaveRequestManager.new
    end

    context 'when jieyang, end day is before the first closing day of the year, annual leave type' do
      it 'should return 4.25' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 1, 14)}
        expect(@manager.left_leave_in_days("Jie Yang", time_period, Summary.types[:annual])).to eq(4.25)
      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return -1.38' do
        time_period = {"start_working_day"=>Date.new(2015, 12, 16), "end_working_day"=>Date.new(2015, 12, 24)}
        expect(@manager.left_leave_in_days("Jie Yang", time_period, Summary.types[:annual]).round(2)).to eq(-1.38)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-2-23' do
      it 'should return 5.42' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 2, 23)}
        expect(@manager.left_leave_in_days("Jie Yang", time_period, Summary.types[:annual]).round(2)).to eq(5.42)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-4-14' do
      it 'should return 1.13' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 14)}
        expect(@manager.left_leave_in_days("Jie Yang", time_period, Summary.types[:annual]).round(2)).to eq(1.13)
      end
    end

  end
end