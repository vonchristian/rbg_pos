class StockTransferPolicy < ApplicationPolicy 
	def new?
		user.proprietor? || user.stock_custodian? || user.sales_clerk?
	end
end