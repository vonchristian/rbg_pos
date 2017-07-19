class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :business_name
      t.string :owner_name
      t.string :address
      t.string :contact_number

      t.timestamps
    end
    add_index :suppliers, :business_name, unique: true
  end
end
