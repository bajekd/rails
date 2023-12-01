# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_231_123_232_241) do
  create_table 'activity_logs', force: :cascade do |t|
    t.integer 'lead_id', null: false
    t.string 'action'
    t.json 'params'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['lead_id'], name: 'index_activity_logs_on_lead_id'
  end

  create_table 'agencies', force: :cascade do |t|
    t.string 'name'
    t.string 'city_name'
    t.integer 'leads_limit'
    t.integer 'city_share_percentage'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'leads_count', default: 0
  end

  create_table 'agents', force: :cascade do |t|
    t.integer 'agency_id', null: false
    t.string 'name'
    t.string 'email'
    t.string 'phone'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['agency_id'], name: 'index_agents_on_agency_id'
    t.index ['email'], name: 'index_agents_on_email', unique: true
    t.index ['phone'], name: 'index_agents_on_phone', unique: true
  end

  create_table 'leads', force: :cascade do |t|
    t.integer 'agency_id'
    t.integer 'agent_id'
    t.string 'name'
    t.string 'email'
    t.string 'phone'
    t.string 'city_name'
    t.string 'address'
    t.string 'state', default: 'pending'
    t.string 'rejected_reason'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['agency_id'], name: 'index_leads_on_agency_id'
    t.index ['agent_id'], name: 'index_leads_on_agent_id'
    t.index ['email'], name: 'index_leads_on_email'
    t.index ['phone'], name: 'index_leads_on_phone'
  end

  add_foreign_key 'activity_logs', 'leads'
  add_foreign_key 'agents', 'agencies'
  add_foreign_key 'leads', 'agencies'
  add_foreign_key 'leads', 'agents'
end
