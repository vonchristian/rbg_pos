module StoreFrontModule
  module Orders
    class StockTransferPolicy < ApplicationPolicy
      def new?
        user.proprietor?
      end
    end
  end
end
