# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_231_018_155_730) do
  create_table 'building_audits', force: :cascade do |t|
    t.string 'manager_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'buildings', force: :cascade do |t|
    t.string 'reference'
    t.string 'address'
    t.string 'zip_code'
    t.string 'city'
    t.string 'country'
    t.string 'manager_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'people', force: :cascade do |t|
    t.string 'reference'
    t.string 'email'
    t.string 'home_phone_number'
    t.string 'mobile_phone_number'
    t.string 'firstname'
    t.string 'lastname'
    t.string 'address'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'person_audits', force: :cascade do |t|
    t.integer 'person_id'
    t.string 'email'
    t.string 'home_phone_number'
    t.string 'mobile_phone_number'
    t.string 'address'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['person_id'], name: 'index_person_audits_on_person_id'
  end
end
