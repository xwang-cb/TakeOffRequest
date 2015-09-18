require 'leave_request/models/annual_statistic'

describe AnnualStatistic do

  describe 'closing_day_based_on_the_start_day' do
    before do
      @annual_statistic = AnnualStatistic.new
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return nil' do
        result = @annual_statistic.closing_day_based_on_the_start_day(Date.new(2015, 12, 16))
        expect(result).to eq(nil)
      end
    end

    context 'when start day is before the closing day of the month' do
      it 'should return the closing day of the month' do
        result = @annual_statistic.closing_day_based_on_the_start_day(Date.new(2015, 1, 1))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(1)
        expect(result.day).to eq(AnnualStatistic::CLOSING_DATE_OF_MONTH)

        result = @annual_statistic.closing_day_based_on_the_start_day(Date.new(2015, 3, 11))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(3)
        expect(result.day).to eq(AnnualStatistic::CLOSING_DATE_OF_MONTH)
      end
    end

    context 'when start day is after the closing day of the month' do
      it 'should return the closing day of next month' do
        result = @annual_statistic.closing_day_based_on_the_start_day(Date.new(2015, 3, 16))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(4)
        expect(result.day).to eq(AnnualStatistic::CLOSING_DATE_OF_MONTH)

        result = @annual_statistic.closing_day_based_on_the_start_day(Date.new(2015, 3, 31))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(4)
        expect(result.day).to eq(AnnualStatistic::CLOSING_DATE_OF_MONTH)
      end
    end

  end

  describe 'num_of_available_closing_day' do
    before do
      @annual_statistic = AnnualStatistic.new
    end

    context 'when end day is before the first closing day of the year' do
      it 'should return 0' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 1, 14)}
        expect(@annual_statistic.num_of_available_closing_day(time_period)).to eq(0)
      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return 0' do
        time_period = {"start_working_day"=>Date.new(2015, 12, 16), "end_working_day"=>Date.new(2015, 12, 24)}
        expect(@annual_statistic.num_of_available_closing_day(time_period)).to eq(0)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-4-23' do
      it 'should return 4' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 23)}
        expect(@annual_statistic.num_of_available_closing_day(time_period)).to eq(4)
      end
    end

    context 'when time period is 2015-1-1 ~ 2015-4-14' do
      it 'should return 4' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 1), "end_working_day"=>Date.new(2015, 4, 14)}
        expect(@annual_statistic.num_of_available_closing_day(time_period)).to eq(3)
      end
    end
  end

  describe 'has_no_available_closing_day?' do # wxhtodo: 补充一些测试
    before do
      @annual_statistic = AnnualStatistic.new
    end

    context 'when end day is before the first closing day of the year' do
      it 'should return false' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 2), "end_working_day"=>Date.new(2015, 1, 14)}
        expect(@annual_statistic.has_no_available_closing_day?(time_period)).to eq(false)
      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return true' do
        time_period = {"start_working_day"=>Date.new(2015, 12, 16), "end_working_day"=>Date.new(2015, 12, 24)}
        expect(@annual_statistic.has_no_available_closing_day?(time_period)).to eq(true)
      end
    end

    context 'when start day and end day are between the first closing day and the last closing day of the year' do
      it 'should return false' do
        time_period = {"start_working_day"=>Date.new(2015, 1, 16), "end_working_day"=>Date.new(2015, 12, 14)}
        expect(@annual_statistic.has_no_available_closing_day?(time_period)).to eq(false)
      end
    end
  end

end
