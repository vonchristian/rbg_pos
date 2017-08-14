class SalesReturnPolicy < ApplicationPolicy 
	def new?
		user.proprietor? || user.sales_clerk? || user.sales_clerk?
	end 
	def create?
		new?
	end
end 