class CreateRepairs < ActiveRecord::Migration[5.1]
  def change
    create_table :repairs do |t|
      t.text :symptoms_observed
      t.text :repair_description

      t.timestamps
    end
  end
end
