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
  def edit?
    user.proprietor?
  end
  def update?
    edit?
  end
end 