module AccountingModule
  module BalanceFinders
    class CommercialDocumentFromDateToDate
      attr_reader :commercial_document, :amounts, :from_date, :to_date

      def initialize(args={})
        @commercial_document = args.fetch(:commercial_document)
        @amounts             = args.fetch(:amounts)
        @from_date           = args.fetch(:from_date)
        @to_date             = args.fetch(:to_date)
      end
      def compute
        amounts.where(commercial_document: commercial_document).
        entered_on(from_date :from_date, to_date: to_date).
        total
      end
    end
  end
end
