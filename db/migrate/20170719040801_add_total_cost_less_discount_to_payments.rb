class AddTotalCostLessDiscountToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :total_cost_less_discount, :decimal
  end
end
