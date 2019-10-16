class AddParentAccountCategoryToAccountCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :account_categories, :parent_account_category, foreign_key: true
  end
end
