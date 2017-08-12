class WarrantyReleasePolicy < ApplicationPolicy
	def new?
		user.proprietor? || user.sales_clerk?
	end 
end 