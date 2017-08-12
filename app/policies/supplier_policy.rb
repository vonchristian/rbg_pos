class SupplierPolicy < ApplicationPolicy 
	def index?
		user.proprietor? || user.stock_custodian?
	end 
	def new?
		user.proprietor? || user.stock_custodian?
	end
	def create?
		new?
	end
end 