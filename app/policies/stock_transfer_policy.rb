class StockTransferPolicy < ApplicationPolicy 
	def new?
		user.proprietor? || user.stock_custodian?
	end
end