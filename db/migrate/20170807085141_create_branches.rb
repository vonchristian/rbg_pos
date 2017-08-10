class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|
      t.belongs_to :business, foreign_key: true
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
