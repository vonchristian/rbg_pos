class SupplierPolicy < ApplicationPolicy 
	def index?
		user.proprietor? || user.stock_custodian?
	end 
end 