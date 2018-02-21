class RemoveDisburserFromVouchers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :vouchers, :disburser, foreign_key: { to_table: :users }
  end
end
