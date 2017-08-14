class UserPolicy < ApplicationPolicy
	def index?
		user.proprietor?
	end 
	def new?
		user.proprietor? 
	end 
	def create?
		new?
	end
end 