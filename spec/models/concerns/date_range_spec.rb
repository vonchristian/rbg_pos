require 'rails_helper'

describe DateRange do


  it 'returns correct dates' do
    date_range   = described_class.new(from_date: "01/01/2019", to_date: '01/01/2019')
    date_range_2 = described_class.new(from_date: Date.today, to_date: Date.today)

    expect(date_range.start_date).to eql DateTime.parse('01/01/2019').strftime('%Y-%m-%d 12:00:00')
    expect(date_range.end_date).to eql DateTime.parse('01/01/2019').strftime('%Y-%m-%d 12:59:59')

    expect(date_range_2.start_date).to eql DateTime.parse(Date.today.to_s).strftime('%Y-%m-%d 12:00:00')
    expect(date_range_2.end_date).to eql DateTime.parse(Date.today.to_s).strftime('%Y-%m-%d 12:59:59')


  end

  it 'end_date' do
  end
end
