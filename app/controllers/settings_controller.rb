class SettingsController < ApplicationController
	def index 
		@business = Business.first
		@users = User.all
		@registry = Registry.new
		authorize :settings
	end 
end 