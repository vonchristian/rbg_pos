class SettingsController < ApplicationController
	def index 
		@business = Business.first
		@users = User.all
		authorize :settings
	end 
end 