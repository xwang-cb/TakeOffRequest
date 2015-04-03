require 'rails_helper'

describe Summary, type: :model do

  describe 'test fixture' do
    context 'when load jieyangs summaries' do
      it "should return 2 records" do
        user = User.find_by_name('Jie Yang')
        expect(user.summaries.count).to eq(2)
      end
    end
  end

  describe 'find method' do
    context 'when load jies 2015 annual left_last_year num' do
      it 'should return 52' do
        user = User.find_by_name('Jie Yang')
        summary = user.summaries.find_by_year_and_type(2015, Summary.types[:annual])
        expect(summary.left_last_year).to eq(52)
      end
    end

    context 'when load jies 2015 medical left_last_year num' do
      it 'should return 2' do
        user = User.find_by_name('Jie Yang')
        summary = user.summaries.find_by_year_and_type(2015, Summary.types[:medical])
        expect(summary.left_last_year).to eq(2)
      end
    end
  end



end
