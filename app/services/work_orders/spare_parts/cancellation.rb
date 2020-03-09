
module WorkOrders
  module SpareParts
    class Cancellation
      attr_reader :line_item, :work_order, :employee

      def initialize(args)
        @employee   = args.fetch(:employee)
        @line_item  = args.fetch(:line_item)
        @work_order = args.fetch(:work_order)
      end
      def cancel!
        ApplicationRecord.transaction do 
          create_entry
          delete_item
        end 
      end

      def create_entry
        EntryCreators::WorkOrders::SparePartCancellationEntry.new(
          work_order: work_order, 
          employee:   employee, 
          line_item:  line_item).
          create_entry!
      end 

      def delete_item
        line_item.destroy
      end
    end
  end
end
