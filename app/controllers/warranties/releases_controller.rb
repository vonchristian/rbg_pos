module Warranties 
	class ReleasesController < ApplicationController
		def create
			authorize :warranty_release, :new?
			@warranty = Warranty.find(params[:warranty_id])
			@warranty.create_warranty_release!(release_date: Time.zone.now, user: current_user)
			@warranty.save 
			redirect_to warranties_url, notice: "Warranty released successfully."
		end 
	end 
end 