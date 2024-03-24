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

ActiveRecord::Schema[7.1].define(version: 2024_03_24_211624) do
  create_table "areas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.integer "hierarchy"
    t.boolean "isDefault"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_areas_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "area_id"
    t.string "name"
    t.string "description"
    t.integer "hierarchy"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_goals_on_area_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "area_id"
    t.integer "goal_id"
    t.string "name"
    t.string "description"
    t.integer "hierarchy"
    t.integer "status"
    t.date "start_date"
    t.date "due_date"
    t.boolean "star"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_projects_on_area_id"
    t.index ["goal_id"], name: "index_projects_on_goal_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "areas", "users"
  add_foreign_key "goals", "areas"
  add_foreign_key "goals", "users"
  add_foreign_key "projects", "areas"
  add_foreign_key "projects", "goals"
  add_foreign_key "projects", "users"
  add_foreign_key "tags", "users"
end
