class ProductPolicy < ApplicationPolicy
	def index?
		true
	end 
	def new?
		user.proprietor? || user.stock_custodian? || user.sales_clerk?
	end
	def create?
		new?
	end
	def edit?
		user.proprietor?
	end 
	def update?
		edit?
	end
end 