class ProductPolicy < ApplicationPolicy
	def index?
		user.proprietor? || user.stock_custodian? || user.sales_clerk?
	end 
	def new?
		user.proprietor? || user.stock_custodian?
	end
	def create?
		new?
	end
end 