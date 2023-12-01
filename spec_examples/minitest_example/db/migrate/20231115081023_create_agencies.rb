class CreateAgencies < ActiveRecord::Migration[7.1]
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :city_name
      t.integer :leads_limit
      t.integer :city_share_percentage

      t.timestamps
    end
  end
end
