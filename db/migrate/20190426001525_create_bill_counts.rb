class CreateBillCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_counts do |t|
      t.belongs_to :bill, foreign_key: true
      t.decimal :bill_count

      t.timestamps
    end
  end
end
