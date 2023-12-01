class AddLeadsCountToAgencies < ActiveRecord::Migration[7.1]
  def change
    add_column :agencies, :leads_count, :integer, default: 0
  end
end
