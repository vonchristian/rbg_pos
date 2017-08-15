class RegistriesController < ApplicationController
	def create
		@registry = Registry.create(registry_params)
		if @registry.save 
			redirect_to settings_url, notice: 'Products imported successfully.'
		else 
			redirect_to settings_url, alert: 'Invalid file.'
		end
	end 

	private 
	def registry_params
		params.require(:registry).permit(:spreadsheet)
	end
end 