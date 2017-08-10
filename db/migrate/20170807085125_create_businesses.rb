class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :owner
      t.string :address
      t.string :email
      t.string :contact_number

      t.timestamps
    end
  end
end
