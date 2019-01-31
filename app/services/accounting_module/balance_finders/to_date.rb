module AccountingModule
  module BalanceFinders
    class Todate
      attr_reader :from_date, :to_date, :amounts

      def initialize(args={})
        @amounts   = args.fetch(:amounts)
        @from_date = 999.years.ago
        @to_date   = args.fetch(:to_date)
      end
      def compute
        amounts.entered_on(from_date: from_date, to_date: to_date).
        total
      end
    end
  end
end
