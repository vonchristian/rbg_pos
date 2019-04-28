class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.string :name
      t.string :amount

      t.timestamps
    end
  end
end
