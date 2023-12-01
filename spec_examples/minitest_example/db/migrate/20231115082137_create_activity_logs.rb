class CreateActivityLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_logs do |t|
      t.belongs_to :lead, null: false, foreign_key: true
      t.string :action
      t.json :params

      t.timestamps
    end
  end
end
