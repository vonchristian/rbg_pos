class CreateWarrantyReleases < ActiveRecord::Migration[5.1]
  def change
    create_table :warranty_releases do |t|
      t.datetime :release_date
      t.belongs_to :user, foreign_key: true
      t.belongs_to :warranty, foreign_key: true
      t.belongs_to :customer, foreign_key: true
      t.string :remarks

      t.timestamps
    end
  end
end
