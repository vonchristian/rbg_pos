class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :account_code
      t.boolean :contra, default: false
      t.string :type

      t.timestamps
    end
    add_index :accounts, :name, unique: true
    add_index :accounts, :account_code, unique: true
    add_index :accounts, :type
  end
end
