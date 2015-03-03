require 'take_off_request_manager'

describe TakeOffRequestManager do

  describe 'closing_day_based_on_the_start_day' do
    before do
      @manager = TakeOffRequestManager.new
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
        expect(result.day).to eq(TakeOffRequestManager::CLOSING_DATE_OF_MONTH)

        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 3, 11))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(3)
        expect(result.day).to eq(TakeOffRequestManager::CLOSING_DATE_OF_MONTH)
      end
    end

    context 'when start day is after the closing day of the month' do
      it 'should return the closing day of next month' do
        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 3, 16))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(4)
        expect(result.day).to eq(TakeOffRequestManager::CLOSING_DATE_OF_MONTH)

        result = @manager.closing_day_based_on_the_start_day(Date.new(2015, 3, 31))
        expect(result.year).to eq(2015)
        expect(result.month).to eq(4)
        expect(result.day).to eq(TakeOffRequestManager::CLOSING_DATE_OF_MONTH)
      end
    end

  end

  describe 'has_no_available_closing_day?' do
    before do
      @manager = TakeOffRequestManager.new
    end

    context 'when end day is before the first closing day of the year' do
      it 'should return true' do
        start_and_end_working_day_of_the_year = {"start_working_day"=>Date.new(2015, 1, 2),
                                                 "end_working_day"=>Date.new(2015, 1, 14)}
        expect(@manager.has_no_available_closing_day?(start_and_end_working_day_of_the_year)).to eq(true)
      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return true' do
        start_and_end_working_day_of_the_year = {"start_working_day"=>Date.new(2015, 12, 16),
                                                 "end_working_day"=>Date.new(2015, 12, 24)}
        expect(@manager.has_no_available_closing_day?(start_and_end_working_day_of_the_year)).to eq(true)
      end
    end

    context 'when start day and end day are between the first closing day and the last closing day of the year' do
      it 'should return false' do
        start_and_end_working_day_of_the_year = {"start_working_day"=>Date.new(2015, 1, 16),
                                                 "end_working_day"=>Date.new(2015, 12, 14)}
        expect(@manager.has_no_available_closing_day?(start_and_end_working_day_of_the_year)).to eq(false)
      end
    end
  end

  describe 'num_of_available_closing_day' do
    before do
      @manager = TakeOffRequestManager.new
    end

    context 'when end day is before the first closing day of the year' do
      it 'should return 0' do

      end
    end

    context 'when start day is after the last closing day of the year' do
      it 'should return 0' do

      end
    end


  end
end