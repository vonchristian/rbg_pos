class WarrantiesController < ApplicationController
	def index 
		if params[:search].present?
			@warranties = Warranty.text_search(params[:search]).page(params[:page]).per(35)
		else
			@warranties = Warranty.all.page(params[:page]).per(35)
		end 
	end 
end 