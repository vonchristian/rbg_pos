module AccountingModule
  module BalanceFinders
    class DefaultBalanceFinder
      attr_reader :from_date, :to_date, :amounts

      def initialize(args={})
        @amounts = args.fetch(:amounts)
      end
      def compute
        amounts.entered_on(from_date: from_date, to_date: to_date).
        total
      end
    end
  end
end
