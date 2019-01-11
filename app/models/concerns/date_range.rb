DateRange = Struct.new(:from_date, :to_date, keyword_init: true) do
  def range
    start_date..end_date
  end

  def start_date
    DateTime.parse(from_date.to_s).strftime('%Y-%m-%d 12:00:00')
  end

  def end_date
    DateTime.parse(to_date.to_s).strftime('%Y-%m-%d 12:59:59')
  end
end
