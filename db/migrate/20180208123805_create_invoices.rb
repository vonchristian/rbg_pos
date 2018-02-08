class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.string :type
      t.string :number
      t.references :invoiceable, polymorphic: true
      t.datetime :date

      t.timestamps
    end
    add_index :invoices, :type
  end
end
