class WarrantiesController < ApplicationController
	def index 
		if params[:search].present?
			@warranties = Warranty.text_search(params[:search]).page(params[:page]).per(35)
		else
			@warranties = Warranty.all.page(params[:page]).per(35)
		end 
	end 
  def edit 
    @warranty = Warranty.find(params[:id])
  end 
  def update 
    @warranty = Warranty.find(params[:id])
    @warranty.update(warranty_params)
    if @warranty.save 
      redirect_to warranties_url, notice: "Warranty updated successfully."
    else 
      render :edit 
    end 
  end 

  private 
  def warranty_params
    params.require(:warranty).permit(:remarks)
  end
end 