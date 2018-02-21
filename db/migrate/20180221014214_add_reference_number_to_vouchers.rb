class AddReferenceNumberToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_column :vouchers, :reference_number, :string
    add_index :vouchers, :reference_number, unique: true
  end
end
