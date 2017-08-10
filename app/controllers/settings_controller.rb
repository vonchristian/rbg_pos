class SettingsController < ApplicationController
	def index 
		@business = Business.first
	end 
end 