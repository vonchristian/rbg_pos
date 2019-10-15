module AccountingModule
  module BalanceFinders
    class FromDateToDate
      attr_reader :from_date, :to_date, :amounts

      def initialize(args={})
        @commercial_document = args.fetch(:commercial_document)
        @from_date           = args.fetch(:from_date)
        @to_date             = args.fetch(:to_date)
      end
      def compute
        amounts.left_joins(:entries).entered_on(from_date: from_date, to_date: to_date).
        total
      end
    end
  end
end
