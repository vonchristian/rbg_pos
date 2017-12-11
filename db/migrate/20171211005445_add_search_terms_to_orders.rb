class AddSearchTermsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :search_term, :string
  end
end
