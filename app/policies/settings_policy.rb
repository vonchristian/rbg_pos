class SettingsPolicy < ApplicationPolicy
	def index?
		user.proprietor?
	end 
end 