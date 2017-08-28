class StockPolicy < ApplicationPolicy 
	def edit?
		destroy?
	end
	def update?
		edit?
	end
	def destroy?
		user.proprietor?
	end
end