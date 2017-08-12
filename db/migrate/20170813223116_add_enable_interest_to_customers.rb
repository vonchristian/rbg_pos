class AddEnableInterestToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :enable_interest, :boolean, default: :false
  end
end
