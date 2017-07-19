class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.string :reference_number
      t.datetime :entry_date
      t.references :commercial_document, polymorphic: true, index: {name: "index_on_commercial_document_entry" }
      t.string :description

      t.timestamps
    end
  end
end
