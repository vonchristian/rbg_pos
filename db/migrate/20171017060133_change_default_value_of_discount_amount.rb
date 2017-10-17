class ChangeDefaultValueOfDiscountAmount < ActiveRecord::Migration[5.1]
  def change
    change_column_default :payments, :discount_amount, 0
  end
end
