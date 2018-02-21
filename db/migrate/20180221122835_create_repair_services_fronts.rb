class CreateRepairServicesFronts < ActiveRecord::Migration[5.1]
  def change
    create_table :repair_services_fronts do |t|
      t.belongs_to :business, foreign_key: true
      t.string :name
      t.string :address
      t.string :contact_number

      t.timestamps
    end
    add_index :repair_services_fronts, :name, unique: true
  end
end
