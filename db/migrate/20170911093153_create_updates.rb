class CreateUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :updates do |t|
      t.references :updateable, polymorphic: true
      t.string :type
      t.string :title
      t.string :content
      t.datetime :date
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :updates, :type
  end
end
