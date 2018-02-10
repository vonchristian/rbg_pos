module StoreFrontModule
  module Settings
    class ProductMerging
      include ActiveModel::Model
      attr_accessor :old_product_id, :new_product_id
      validates :old_product_id, :new_product_id, presence: true
      validate :not_the_same_product?
      def merge_products!
        ActiveRecord::Base.transaction do
          merge_products
        end
      end
      private
      def merge_products
        old_product = Product.find_by_id(old_product_id)
        new_product = Product.find_by_id(new_product_id)
        new_product.stocks               << old_product.stocks
        new_product.unit_of_measurements << old_product.unit_of_measurements
        new_product.purchases            << old_product.purchases
        new_product.sales                << old_product.sales
        new_product.sales_returns        << old_product.sales_returns
        new_product.purchase_returns     << old_product.purchase_returns
        new_product.spoilages            << old_product.spoilages
        old_product.destroy
      end
      def not_the_same_product?
        errors[:old_supplier_id] << "Cannot be the same supplier" if self.old_product_id == new_product_id
      end
    end
  end
end
