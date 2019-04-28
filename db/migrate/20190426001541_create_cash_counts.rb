class CreateCashCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_counts do |t|
      t.belongs_to :employee, foreign_key: { to_table: :users }
      t.datetime :date

      t.timestamps
    end
  end
end
