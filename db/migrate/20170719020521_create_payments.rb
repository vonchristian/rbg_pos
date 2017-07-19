class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.belongs_to :order, foreign_key: true
      t.integer :mode_of_payment
      t.decimal :discount_amount
      t.decimal :cash_tendered
      t.decimal :change
      t.decimal :total_cost

      t.timestamps
    end
  end
end
