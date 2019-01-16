class AddBusinessToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :business, foreign_key: true
  end
end
