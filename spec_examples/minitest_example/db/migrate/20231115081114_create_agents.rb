class CreateAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :agents do |t|
      t.belongs_to :agency, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end

    add_index :agents, :email, unique: true
    add_index :agents, :phone, unique: true
  end
end
