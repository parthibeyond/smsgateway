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

ActiveRecord::Schema[7.1].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account", id: :serial, force: :cascade do |t|
    t.string "auth_id", limit: 40
    t.string "username", limit: 30
  end

  create_table "phone_number", id: :serial, force: :cascade do |t|
    t.string "number", limit: 40
    t.integer "account_id"
  end

  add_foreign_key "phone_number", "account", name: "phone_number_account_id_fkey"
end
