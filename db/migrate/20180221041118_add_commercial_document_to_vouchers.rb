class AddCommercialDocumentToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_reference :vouchers, :commercial_document, polymorphic: true, index: { name: "index_commercial_document_on_vouchers" }
  end
end
