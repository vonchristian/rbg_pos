module StoreFrontModule
  module Registries
    class StockTransferRegistriesController < ApplicationController
      def new
        @registry = StoreFrontModule::Registries::StockTransferRegistry.new
      end
      def create
        @registry = StoreFrontModule::Registries::StockTransferRegistry.new(registry_params)
        if @registry.save
          @registry.parse_for_records
          redirect_to store_front_module_stock_transfer_registry_url(@registry), notice: "uploaded successfully"
        else
          render :new
        end
      end
      def show
        @registry = StoreFrontModule::Registries::StockTransferRegistry.find(params[:id])
        @cart = current_cart
        @stock_transfer_order = StoreFrontModule::Orders::StockTransferOrderProcessing.new
      end
      private
      def registry_params
        params.require(:store_front_module_registries_stock_transfer_registry).
        permit(:spreadsheet)
      end
    end
  end
end
