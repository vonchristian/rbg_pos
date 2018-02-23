module StoreFrontModule
  class PurchaseOrderLineItemRegistriesController < ApplicationController
    def create
      @registry = Registries::PurchaseOrderLineItemRegistry.create(registry_params)
      if @registry.valid?
        @registry.save
        redirect_to @registry, notice: 'imported successfully.'
      else
        redirect_to new_store_front_module_purchase_order_line_item_processing_url, alert: 'Invalid file.'
      end
    end
    def show
      @registry = Registry.find(params[:id])
      @stocks = @registry.stocks.all.paginate(page: params[:page], per_page: 35)
    end
    def destroy
      @registry = Registry.find(params[:id])
      @registry.destroy
      redirect_to products_url, notice: "Deleted successfully."
    end

    private
    def registry_params
      params.require(:registries_purchase_order_line_item_registry).permit(:spreadsheet)
    end
  end
end
