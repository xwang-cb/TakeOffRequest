require 'rails_helper'

describe YearPreference, type: :model do
  describe 'pass_clean_day_of_the_year?' do
    context 'when year is 2015 and date is Date(2015, 2, 28)' do
      it 'should return false' do
        expect(YearPreference.pass_clean_day_of_the_year?('2015', Date.new(2015, 2, 28))).to eq(false)
      end
    end

    context 'when year is 2015 and date is Date(2015, 3, 1)' do
      it 'should return true' do
        expect(YearPreference.pass_clean_day_of_the_year?('2015', Date.new(2015, 3, 1))).to eq(true)
      end
    end

    context 'when year is 2014 and date is Date(2014, 1, 31)' do
      it 'should return false' do
        expect(YearPreference.pass_clean_day_of_the_year?('2014', Date.new(2014, 1, 31))).to eq(false)
      end
    end

    context 'when year is 2014 and date is Date(2014, 2, 1)' do
      it 'should return true' do
        expect(YearPreference.pass_clean_day_of_the_year?('2014', Date.new(2014, 2, 1))).to eq(true)
      end
    end

    context 'when year is 2015 and date is Date(2015, 3, 1)' do
      it 'should raise exception' do
        expect{YearPreference.pass_clean_day_of_the_year?('2014', Date.new(2015, 3, 1))}.to raise_error("parameter error: year and date should like year=>2015, date=>'2015-03-01'")
      end
    end
  end
end
