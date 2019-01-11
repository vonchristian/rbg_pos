module StoreFrontModule
  module Orders
    class WarrantyReturnOrder < Order

      def supplier
        commercial_document
      end
    end
  end
end
