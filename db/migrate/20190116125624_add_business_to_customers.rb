class AddBusinessToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_reference :customers, :business, foreign_key: true
  end
end
