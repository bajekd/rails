class CreateLeads < ActiveRecord::Migration[7.1]
  def change
    create_table :leads do |t|
      t.belongs_to :agency, null: true, foreign_key: true
      t.belongs_to :agent, null: true, foreign_key: true
      t.string :name
      t.string :email, index: true
      t.string :phone, index: true
      t.string :city_name
      t.string :address
      t.string :state, default: 'pending'
      t.string :rejected_reason

      t.timestamps
    end
  end
end
