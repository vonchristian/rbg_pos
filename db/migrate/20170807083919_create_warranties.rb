class CreateWarranties < ActiveRecord::Migration[5.1]
  def change
    create_table :warranties do |t|
      t.references :warrantable,  polymorphic: true, index: true
      t.datetime :date_received
      t.datetime :released_date

      t.timestamps
    end
  end
end
