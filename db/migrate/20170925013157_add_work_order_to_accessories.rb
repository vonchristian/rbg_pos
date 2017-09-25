class AddWorkOrderToAccessories < ActiveRecord::Migration[5.1]
  def change
    add_reference :accessories, :work_order, foreign_key: true
  end
end
