class RegistriesController < ApplicationController
	def create
		@registry = Registry.create(registry_params)
		if @registry.save 
			redirect_to @registry, notice: 'Stocks imported successfully.'
		else 
			redirect_to stocks_url, alert: 'Invalid file.'
		end
	end 
  def show 
    @registry = Registry.find(params[:id])
    @stocks = @registry.stocks.all.page(params[:page]).per(35)
  end
  def destroy
    @registry = Registry.find(params[:id])
    @registry.destroy 
    redirect_to products_url, notice: "Deleted successfully."
  end

	private 
	def registry_params
		params.require(:registry).permit(:spreadsheet)
	end
end 