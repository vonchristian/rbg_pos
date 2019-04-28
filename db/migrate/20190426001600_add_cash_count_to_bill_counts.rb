class AddCashCountToBillCounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :bill_counts, :cash_count, foreign_key: true
  end
end
