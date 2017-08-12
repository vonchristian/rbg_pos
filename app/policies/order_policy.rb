class OrderPolicy < ApplicationPolicy 
	def index?
		user.proprietor? || user.sales_clerk?
	end
end