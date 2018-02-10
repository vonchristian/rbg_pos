class AddCommercialDocumentToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :commercial_document, polymorphic: true, index: { name: 'index_commercial_document_on_orders' }
  end
end
