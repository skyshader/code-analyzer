# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151208122539) do

  create_table "admin_logs", force: :cascade do |t|
    t.string   "username",     limit: 50
    t.string   "ipaddress",    limit: 45
    t.datetime "logtime"
    t.string   "controller",   limit: 245
    t.string   "action",       limit: 145
    t.text     "details",      limit: 65535
    t.string   "action_param", limit: 60
    t.text     "browser",      limit: 65535
    t.text     "query_string", limit: 65535
    t.text     "refer_url",    limit: 65535
    t.integer  "user_id",      limit: 4
    t.text     "request_url",  limit: 65535
  end

  create_table "affiliate", force: :cascade do |t|
    t.integer  "users_id",        limit: 4,     null: false
    t.string   "first_name",      limit: 45
    t.string   "last_name",       limit: 45
    t.string   "company_name",    limit: 45
    t.string   "company_link",    limit: 245
    t.string   "skype_id",        limit: 100
    t.string   "email",           limit: 45
    t.string   "phone_number",    limit: 45
    t.string   "address",         limit: 250
    t.string   "team_size",       limit: 45
    t.string   "category",        limit: 50
    t.string   "foundation_year", limit: 5
    t.string   "image",           limit: 500
    t.text     "description",     limit: 65535
    t.datetime "add_date"
    t.integer  "status",          limit: 1
  end

  add_index "affiliate", ["users_id"], name: "fk_affiliate_users1_idx", using: :btree

  create_table "awards_certifications", force: :cascade do |t|
    t.string  "image",        limit: 100
    t.string  "link",         limit: 100
    t.string  "description",  limit: 255
    t.integer "suppliers_id", limit: 4,   null: false
  end

  add_index "awards_certifications", ["suppliers_id"], name: "fk_awards_certifications_suppliers1_idx", using: :btree

  create_table "calculator_category", force: :cascade do |t|
    t.string   "name",        limit: 100,               null: false
    t.text     "description", limit: 65535,             null: false
    t.datetime "created"
    t.datetime "modified"
    t.integer  "is_deleted",  limit: 1,     default: 0, null: false
    t.integer  "is_cal_lpu",  limit: 1,     default: 0, null: false
  end

  create_table "calculator_options", force: :cascade do |t|
    t.integer  "question_id", limit: 4,                   null: false
    t.text     "options",     limit: 65535,               null: false
    t.string   "hour",        limit: 100,   default: "1"
    t.string   "price",       limit: 100,   default: "0"
    t.datetime "created"
    t.datetime "modified"
    t.string   "icon",        limit: 50
    t.integer  "is_deleted",  limit: 1,     default: 0,   null: false
  end

  add_index "calculator_options", ["question_id"], name: "question_id", using: :btree

  create_table "calculator_question", force: :cascade do |t|
    t.integer  "parent",      limit: 4
    t.integer  "category_id", limit: 4,                 null: false
    t.string   "question",    limit: 500,               null: false
    t.text     "description", limit: 65535
    t.integer  "multi",       limit: 1,                 null: false
    t.datetime "created"
    t.datetime "modified"
    t.integer  "is_deleted",  limit: 1,     default: 0, null: false
    t.integer  "is_cal_lpu",  limit: 1,     default: 0, null: false
  end

  add_index "calculator_question", ["category_id"], name: "category_id", using: :btree

  create_table "calculator_result", force: :cascade do |t|
    t.integer  "users_id",    limit: 4, null: false
    t.integer  "question_id", limit: 4, null: false
    t.integer  "option_id",   limit: 4, null: false
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "calculator_result", ["option_id"], name: "option_id", using: :btree
  add_index "calculator_result", ["question_id"], name: "question_id", using: :btree
  add_index "calculator_result", ["question_id"], name: "question_id_2", using: :btree
  add_index "calculator_result", ["users_id"], name: "users_id", using: :btree

  create_table "calculator_users", force: :cascade do |t|
    t.string   "username",     limit: 200
    t.string   "total_price",  limit: 100
    t.string   "total_hour",   limit: 100
    t.integer  "status",       limit: 1,   default: 0, null: false
    t.datetime "created"
    t.string   "phone_number", limit: 20
    t.datetime "modified"
    t.string   "hash_val",     limit: 100
    t.integer  "is_user_lpu",  limit: 1,   default: 0, null: false
  end

  create_table "call_schedules", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.text     "details",           limit: 65535
    t.string   "client_phone",      limit: 25
    t.string   "call_time",         limit: 100
    t.integer  "time_zone",         limit: 4
    t.integer  "login_id",          limit: 4
    t.datetime "add_date"
    t.integer  "status",            limit: 1
    t.datetime "modification_date"
  end

  add_index "call_schedules", ["time_zone"], name: "fk_call_schedules_client_projects1_idx", using: :btree

  create_table "call_schedules_slot", force: :cascade do |t|
    t.string  "name",        limit: 50
    t.text    "description", limit: 65535
    t.date    "add_date"
    t.string  "category",    limit: 50,    default: "1", null: false
    t.integer "status",      limit: 1,     default: 1,   null: false
    t.string  "value",       limit: 100
  end

  create_table "chat_call_schedule", force: :cascade do |t|
    t.integer  "chat_room_id", limit: 4,               null: false
    t.string   "description",  limit: 250
    t.integer  "status",       limit: 1,   default: 1, null: false
    t.datetime "created"
    t.datetime "modified"
    t.integer  "add_by",       limit: 4,   default: 0, null: false
  end

  add_index "chat_call_schedule", ["chat_room_id"], name: "chat_room_id", using: :btree

  create_table "chat_call_schedule_slots", force: :cascade do |t|
    t.integer  "chat_call_schedule_id", limit: 4,               null: false
    t.string   "title",                 limit: 100
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.integer  "status",                limit: 1,   default: 1, null: false
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "chat_call_schedule_slots", ["chat_call_schedule_id"], name: "chat_call_schedule_id", using: :btree

  create_table "chat_messages", force: :cascade do |t|
    t.integer  "chat_template_id",         limit: 4,                 null: false
    t.integer  "chat_message_has_user_id", limit: 4,                 null: false
    t.string   "type",                     limit: 45
    t.text     "message",                  limit: 65535
    t.string   "ip_address",               limit: 45
    t.integer  "sender_type",              limit: 1
    t.integer  "status",                   limit: 1,     default: 1
    t.datetime "add_date"
    t.integer  "chat_room_id",             limit: 4,                 null: false
    t.integer  "proposal_id",              limit: 4
    t.integer  "is_sent_from_supplier",    limit: 1
    t.integer  "flag",                     limit: 4
  end

  add_index "chat_messages", ["chat_message_has_user_id"], name: "fk_chat_messages_chat_room_has_users1_idx", using: :btree
  add_index "chat_messages", ["chat_message_has_user_id"], name: "user_id", using: :btree
  add_index "chat_messages", ["chat_room_id"], name: "chat_room_id", using: :btree
  add_index "chat_messages", ["chat_template_id"], name: "fk_chat_messages_chat_template1_idx", using: :btree

  create_table "chat_room", force: :cascade do |t|
    t.string   "room_type", limit: 45,    default: "0"
    t.string   "room_name", limit: 45
    t.datetime "add_date"
    t.integer  "status",    limit: 1
    t.text     "remarks",   limit: 65535
  end

  create_table "chat_room_has_users", force: :cascade do |t|
    t.integer  "chat_room_id",  limit: 4,               null: false
    t.integer  "users_id",      limit: 4,               null: false
    t.string   "added_by",      limit: 255
    t.datetime "add_date"
    t.integer  "users_type",    limit: 1,   default: 0
    t.string   "hash",          limit: 100
    t.integer  "status",        limit: 1
    t.integer  "message_count", limit: 4,   default: 0
  end

  add_index "chat_room_has_users", ["chat_room_id"], name: "fk_chat_room_has_users_chat_room1_idx", using: :btree
  add_index "chat_room_has_users", ["hash"], name: "hash", using: :btree
  add_index "chat_room_has_users", ["users_id"], name: "fk_chat_room_has_users_users1_idx", using: :btree

  create_table "chat_seen_by", force: :cascade do |t|
    t.integer  "chat_messages_id", limit: 4,             null: false
    t.integer  "users_id",         limit: 4,             null: false
    t.datetime "add_date"
    t.integer  "status",           limit: 1, default: 1, null: false
  end

  add_index "chat_seen_by", ["chat_messages_id", "users_id"], name: "unique_index", unique: true, using: :btree
  add_index "chat_seen_by", ["chat_messages_id"], name: "chat_messages_id", using: :btree
  add_index "chat_seen_by", ["users_id"], name: "users_id", using: :btree

  create_table "chat_template", force: :cascade do |t|
    t.string   "name",         limit: 45
    t.text     "template",     limit: 65535
    t.text     "placeholders", limit: 65535
    t.datetime "add_date"
    t.integer  "status",       limit: 1
  end

  create_table "cities", force: :cascade do |t|
    t.string  "name",         limit: 45
    t.string  "code",         limit: 45
    t.string  "description",  limit: 245
    t.string  "others",       limit: 45
    t.string  "geo_lat",      limit: 100
    t.string  "geo_lng",      limit: 100
    t.integer "status",       limit: 1
    t.integer "countries_id", limit: 4,   null: false
  end

  add_index "cities", ["countries_id"], name: "fk_cities_countries1_idx", using: :btree
  add_index "cities", ["name"], name: "name", using: :btree

  create_table "client_milestones", force: :cascade do |t|
    t.integer "client_profiles_id", limit: 4,  null: false
    t.string  "name",               limit: 45
    t.string  "desc",               limit: 45
    t.string  "payment",            limit: 45
    t.string  "mod_date",           limit: 45
    t.string  "payment_date",       limit: 45
    t.string  "add_date",           limit: 45
    t.string  "status",             limit: 45
  end

  add_index "client_milestones", ["client_profiles_id"], name: "fk_client_milestones_client_profiles1_idx", using: :btree

  create_table "client_payment", force: :cascade do |t|
    t.integer "client_milestones_id", limit: 4,  null: false
    t.string  "title",                limit: 45
    t.string  "desc",                 limit: 45
    t.string  "add_date",             limit: 45
    t.string  "status",               limit: 45
    t.string  "note",                 limit: 45
    t.string  "payment_status",       limit: 45
    t.string  "transaction_id",       limit: 45
    t.string  "transaction_status",   limit: 45
  end

  add_index "client_payment", ["client_milestones_id"], name: "fk_client_payment_client_milestones1_idx", using: :btree

  create_table "client_portfolio", force: :cascade do |t|
    t.string "client_id",  limit: 45
    t.string "project_id", limit: 45
    t.string "type",       limit: 45
    t.string "service",    limit: 45
    t.string "skill",      limit: 45
    t.string "add_date",   limit: 45
    t.string "status",     limit: 45
  end

  create_table "client_profile_view", force: :cascade do |t|
    t.string "clientIpAdress",    limit: 50, null: false
    t.string "SupplierProfileId", limit: 10, null: false
  end

  create_table "client_profiles", force: :cascade do |t|
    t.integer  "users_id",        limit: 4,                 null: false
    t.string   "first_name",      limit: 45
    t.string   "last_name",       limit: 45
    t.string   "company_name",    limit: 45
    t.string   "company_link",    limit: 245
    t.string   "skype_id",        limit: 100
    t.string   "email",           limit: 45
    t.string   "phone_number",    limit: 45
    t.string   "address1",        limit: 250
    t.string   "team_size",       limit: 45
    t.string   "category",        limit: 50
    t.string   "foundation_year", limit: 5
    t.string   "image",           limit: 500
    t.text     "description",     limit: 65535
    t.datetime "add_date"
    t.integer  "status",          limit: 1
    t.integer  "manager_id",      limit: 4,     default: 1
  end

  add_index "client_profiles", ["manager_id"], name: "fk_client_profiles_manager1_idx", using: :btree
  add_index "client_profiles", ["users_id"], name: "fk_client_profiles_users1_idx", using: :btree

  create_table "client_profiles_has_cities", force: :cascade do |t|
    t.integer  "client_profiles_id", limit: 4,             null: false
    t.integer  "cities_id",          limit: 4,             null: false
    t.integer  "is_main",            limit: 1, default: 0
    t.datetime "add_date"
    t.integer  "status",             limit: 1
  end

  add_index "client_profiles_has_cities", ["cities_id"], name: "fk_client_profiles_has_cities_cities1_idx", using: :btree
  add_index "client_profiles_has_cities", ["client_profiles_id"], name: "fk_client_profiles_has_cities_client_profiles1_idx", using: :btree

  create_table "client_project_documents", force: :cascade do |t|
    t.string   "name",               limit: 245
    t.string   "path",               limit: 245
    t.string   "extension",          limit: 45
    t.string   "size",               limit: 45
    t.string   "type",               limit: 45
    t.datetime "add_date"
    t.integer  "status",             limit: 1
    t.integer  "client_projects_id", limit: 4,   null: false
    t.integer  "ref_type",           limit: 1
  end

  add_index "client_project_documents", ["client_projects_id"], name: "fk_client_project_documents_client_projects1_idx", using: :btree

  create_table "client_project_flows", force: :cascade do |t|
    t.string  "step",               limit: 45
    t.text    "description",        limit: 65535
    t.integer "status",             limit: 1
    t.integer "client_projects_id", limit: 4,     null: false
  end

  add_index "client_project_flows", ["client_projects_id"], name: "fk_client_project_flows_client_projects1_idx", using: :btree

  create_table "client_project_progress", force: :cascade do |t|
    t.string  "name",               limit: 45
    t.text    "details",            limit: 65535
    t.integer "status",             limit: 1
    t.integer "client_projects_id", limit: 4,     null: false
  end

  add_index "client_project_progress", ["client_projects_id"], name: "fk_client_project_progress_client_projects1_idx", using: :btree

  create_table "client_project_status", force: :cascade do |t|
    t.integer "client_portfolio_id", limit: 4,  null: false
    t.string  "name",                limit: 45
    t.string  "desc",                limit: 45
    t.string  "add_date",            limit: 45
    t.string  "status",              limit: 45
  end

  add_index "client_project_status", ["client_portfolio_id"], name: "fk_client_project_status_client_portfolio1_idx", using: :btree

  create_table "client_projects", force: :cascade do |t|
    t.text     "name",                     limit: 65535
    t.text     "description",              limit: 65535
    t.string   "tag_line",                 limit: 100
    t.text     "business_problem",         limit: 65535
    t.text     "about_company",            limit: 65535
    t.string   "team_size",                limit: 45
    t.text     "summary",                  limit: 65535
    t.integer  "is_abandon",               limit: 1,     default: 0
    t.string   "min_budget",               limit: 25
    t.string   "max_budget",               limit: 25
    t.string   "custom_budget_range",      limit: 45
    t.datetime "start_date"
    t.string   "project_start_preference", limit: 100
    t.string   "preferences",              limit: 45
    t.string   "regions",                  limit: 45
    t.string   "tier",                     limit: 45
    t.string   "call_time_zone",           limit: 150,   default: "1", null: false
    t.string   "call_available_time",      limit: 100
    t.string   "mobile",                   limit: 45
    t.text     "questions_for_supplier",   limit: 65535
    t.string   "requirement_change_scale", limit: 45
    t.datetime "add_date"
    t.string   "is_call_scheduled",        limit: 45
    t.string   "other_status",             limit: 45
    t.string   "current_status",           limit: 45
    t.integer  "status",                   limit: 4
    t.integer  "client_profiles_id",       limit: 4,                   null: false
    t.integer  "current_status_id",        limit: 4,                   null: false
    t.string   "other_current_status",     limit: 100
    t.integer  "state",                    limit: 4
    t.datetime "modify_date"
    t.integer  "outside_venturepact",      limit: 1,     default: 0
    t.integer  "matched_supplier",         limit: 1,     default: 0
    t.integer  "budget_limit",             limit: 1,     default: 0
    t.integer  "no_revert",                limit: 1,     default: 0
    t.text     "abandon_comments",         limit: 65535
    t.integer  "request_abandon",          limit: 1,     default: 0
    t.integer  "lead_score",               limit: 4,     default: 0
    t.text     "admin_comments",           limit: 65535
    t.integer  "admin_mail_sent",          limit: 1,     default: 0,   null: false
    t.integer  "lead_owner",               limit: 4,     default: 0
    t.integer  "is_deleted",               limit: 1,     default: 0,   null: false
  end

  add_index "client_projects", ["client_profiles_id"], name: "fk_client_projects_client_profiles1_idx", using: :btree
  add_index "client_projects", ["current_status_id"], name: "fk_client_projects_current_status1_idx", using: :btree

  create_table "client_projects_has_industries", force: :cascade do |t|
    t.integer  "client_projects_id", limit: 4, null: false
    t.integer  "industries_id",      limit: 4, null: false
    t.datetime "add_date"
    t.integer  "status",             limit: 1
  end

  add_index "client_projects_has_industries", ["client_projects_id"], name: "fk_client_projects_has_industries_client_projects1_idx", using: :btree
  add_index "client_projects_has_industries", ["industries_id"], name: "fk_client_projects_has_industries_industries1_idx", using: :btree

  create_table "client_projects_has_services", force: :cascade do |t|
    t.integer  "client_projects_id", limit: 4, null: false
    t.integer  "services_id",        limit: 4, null: false
    t.integer  "status",             limit: 1
    t.datetime "add_date"
  end

  add_index "client_projects_has_services", ["client_projects_id"], name: "fk_client_projects_has_services_client_projects1_idx", using: :btree
  add_index "client_projects_has_services", ["services_id"], name: "fk_client_projects_has_services_services1_idx", using: :btree

  create_table "client_projects_has_skills", force: :cascade do |t|
    t.integer  "client_projects_id", limit: 4, null: false
    t.integer  "skills_id",          limit: 4, null: false
    t.integer  "status",             limit: 1
    t.datetime "add_date"
  end

  add_index "client_projects_has_skills", ["client_projects_id"], name: "fk_client_projects_has_skills_client_projects1_idx", using: :btree
  add_index "client_projects_has_skills", ["skills_id"], name: "fk_client_projects_has_skills_skills1_idx", using: :btree

  create_table "client_projects_has_tags", force: :cascade do |t|
    t.integer  "client_projects_id", limit: 4,               null: false
    t.integer  "tag_id",             limit: 4,               null: false
    t.integer  "is_deleted",         limit: 4,   default: 0, null: false
    t.datetime "add_date"
    t.datetime "modify_date"
    t.string   "notes",              limit: 250
    t.string   "comments",           limit: 250
    t.integer  "status",             limit: 4,   default: 1, null: false
  end

  add_index "client_projects_has_tags", ["client_projects_id"], name: "fk_tag_project", using: :btree
  add_index "client_projects_has_tags", ["tag_id"], name: "fk_tag_tags", using: :btree

  create_table "client_projects_questions", force: :cascade do |t|
    t.text     "question",           limit: 65535
    t.text     "description",        limit: 65535
    t.text     "title",              limit: 65535
    t.datetime "add_date"
    t.integer  "status",             limit: 1
    t.integer  "client_projects_id", limit: 4,     null: false
  end

  add_index "client_projects_questions", ["client_projects_id"], name: "fk_client_projects_questions_client_projects1_idx", using: :btree

  create_table "client_services", force: :cascade do |t|
    t.integer "client_profiles_id", limit: 4,  null: false
    t.string  "services_id",        limit: 45
    t.string  "add_date",           limit: 45
    t.string  "status",             limit: 45
    t.string  "active",             limit: 45
  end

  add_index "client_services", ["client_profiles_id"], name: "fk_client_services_client_profiles1_idx", using: :btree

  create_table "client_team", force: :cascade do |t|
    t.integer "client_portfolio_id", limit: 4,  null: false
    t.string  "team_id",             limit: 45
    t.string  "add_date",            limit: 45
    t.string  "status",              limit: 45
    t.string  "active",              limit: 45
  end

  add_index "client_team", ["client_portfolio_id"], name: "fk_client_team_client_portfolio1_idx", using: :btree

  create_table "code_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "code_review_categories", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "code_category_id", limit: 4
    t.integer  "code_review_id",   limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "code_review_categories", ["code_category_id"], name: "index_code_review_categories_on_code_category_id", using: :btree
  add_index "code_review_categories", ["code_review_id"], name: "index_code_review_categories_on_code_review_id", using: :btree

  create_table "code_reviews", force: :cascade do |t|
    t.string   "issue_type",         limit: 255
    t.string   "check_name",         limit: 255
    t.text     "description",        limit: 65535
    t.string   "engine_name",        limit: 255
    t.string   "file_path",          limit: 255
    t.integer  "line_begin",         limit: 4
    t.integer  "line_end",           limit: 4
    t.string   "remediation_points", limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string  "name",          limit: 45
    t.string  "description",   limit: 255
    t.string  "code",          limit: 10
    t.string  "code2",         limit: 10
    t.string  "geo_lat",       limit: 100
    t.string  "geo_lng",       limit: 100
    t.string  "status",        limit: 45
    t.integer "regions_id",    limit: 4,   null: false
    t.integer "price_zone_id", limit: 4,   null: false
  end

  add_index "countries", ["regions_id"], name: "fk_countries_regions1_idx", using: :btree

  create_table "current_status", force: :cascade do |t|
    t.string  "name",        limit: 45
    t.string  "description", limit: 245
    t.string  "position",    limit: 45
    t.integer "status",      limit: 1
  end

  create_table "decline_partner_questions", force: :cascade do |t|
    t.string   "title",       limit: 250,               null: false
    t.text     "description", limit: 65535,             null: false
    t.integer  "type",        limit: 1,     default: 0, null: false
    t.datetime "add_date",                              null: false
    t.integer  "status",      limit: 1,                 null: false
  end

  create_table "decline_response", force: :cascade do |t|
    t.integer  "decline_partner_questions_id", limit: 4,                 null: false
    t.integer  "suppliers_projects_id",        limit: 4,                 null: false
    t.integer  "decline_by",                   limit: 1,     default: 0
    t.text     "answers",                      limit: 65535
    t.text     "note",                         limit: 65535
    t.datetime "add_date",                                               null: false
    t.integer  "status",                       limit: 1,                 null: false
  end

  add_index "decline_response", ["decline_partner_questions_id"], name: "partner_question_idx", using: :btree
  add_index "decline_response", ["suppliers_projects_id"], name: "supplierProject_id_idx", using: :btree

  create_table "email_logs", force: :cascade do |t|
    t.string   "reciver",    limit: 100
    t.string   "templete",   limit: 150
    t.text     "esubject",   limit: 65535
    t.text     "body",       limit: 65535
    t.datetime "time"
    t.integer  "status",     limit: 1
    t.text     "other_info", limit: 65535
    t.integer  "user_id",    limit: 4
  end

  create_table "error_logs", force: :cascade do |t|
    t.string   "user_type",     limit: 15
    t.text     "user_name",     limit: 65535
    t.integer  "error_code",    limit: 4
    t.text     "message",       limit: 65535
    t.text     "request_url",   limit: 65535
    t.text     "query_string",  limit: 65535
    t.text     "file_name",     limit: 65535
    t.integer  "line_number",   limit: 4
    t.string   "error_type",    limit: 45
    t.datetime "time"
    t.text     "reference_url", limit: 65535
    t.string   "ipaddress",     limit: 45
    t.text     "browser",       limit: 65535
    t.integer  "user_id",       limit: 4
  end

  create_table "faq", force: :cascade do |t|
    t.string   "type",     limit: 100
    t.text     "question", limit: 65535
    t.datetime "add_date"
    t.integer  "status",   limit: 1
  end

  create_table "in_comment_has_reports", force: :cascade do |t|
    t.integer  "in_post_has_comments_id", limit: 4,              null: false
    t.integer  "users_id",                limit: 4,              null: false
    t.integer  "status",                  limit: 1,  default: 1
    t.datetime "created"
    t.string   "modified",                limit: 45
  end

  add_index "in_comment_has_reports", ["in_post_has_comments_id"], name: "fk_in_comment_has_reports_in_users_has_comments1_idx", using: :btree
  add_index "in_comment_has_reports", ["users_id"], name: "fk_in_comment_has_reports_users1_idx", using: :btree

  create_table "in_comment_has_shares", force: :cascade do |t|
    t.integer  "in_post_has_comments_id", limit: 4,              null: false
    t.integer  "users_id",                limit: 4,              null: false
    t.integer  "status",                  limit: 1,  default: 1
    t.string   "type",                    limit: 45
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_comment_has_shares", ["in_post_has_comments_id"], name: "fk_in_comment_has_shares_in_users_has_comments1_idx", using: :btree
  add_index "in_comment_has_shares", ["users_id"], name: "fk_in_comment_has_shares_users1_idx", using: :btree

  create_table "in_comment_has_upvotes", force: :cascade do |t|
    t.integer  "users_id",                limit: 4,             null: false
    t.integer  "in_post_has_comments_id", limit: 4,             null: false
    t.integer  "status",                  limit: 1, default: 1
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_comment_has_upvotes", ["in_post_has_comments_id"], name: "fk_in_comment_has_upvotes_in_users_has_comments1_idx", using: :btree
  add_index "in_comment_has_upvotes", ["users_id"], name: "fk_in_comment_has_upvotes_users1_idx", using: :btree

  create_table "in_comment_has_users", force: :cascade do |t|
    t.integer  "status",                  limit: 1, default: 1
    t.datetime "created"
    t.datetime "modified"
    t.integer  "in_post_has_comments_id", limit: 4,             null: false
    t.integer  "users_id",                limit: 4,             null: false
  end

  add_index "in_comment_has_users", ["in_post_has_comments_id"], name: "fk_in_comment_has_users_in_post_has_comments1_idx", using: :btree
  add_index "in_comment_has_users", ["users_id"], name: "fk_in_comment_has_users_users1_idx", using: :btree

  create_table "in_comments_closure", id: false, force: :cascade do |t|
    t.integer "parent", limit: 4,             null: false
    t.integer "child",  limit: 4,             null: false
    t.integer "depth",  limit: 4, default: 0, null: false
  end

  add_index "in_comments_closure", ["child"], name: "fk_in_comments_closure_child_comment", using: :btree

  create_table "in_enterprise_has_index", force: :cascade do |t|
    t.integer  "in_user_enterprise_id",  limit: 4,             null: false
    t.integer  "in_innovation_index_id", limit: 4,             null: false
    t.integer  "status",                 limit: 1, default: 1, null: false
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_enterprise_has_index", ["in_innovation_index_id"], name: "fk_enterprise_has_index", using: :btree
  add_index "in_enterprise_has_index", ["in_user_enterprise_id"], name: "fk_enterprise_index", using: :btree

  create_table "in_enterprise_has_users", force: :cascade do |t|
    t.integer  "status",                limit: 1, default: 1, null: false
    t.integer  "users_id",              limit: 4,             null: false
    t.integer  "in_role_id",            limit: 4
    t.integer  "in_user_enterprise_id", limit: 4,             null: false
    t.integer  "invited",               limit: 1, default: 0
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_enterprise_has_users", ["in_role_id"], name: "fk_role2", using: :btree
  add_index "in_enterprise_has_users", ["in_user_enterprise_id"], name: "in_user_enterprise_id", using: :btree
  add_index "in_enterprise_has_users", ["users_id", "in_user_enterprise_id"], name: "fk_unique_user_enterprise", unique: true, using: :btree
  add_index "in_enterprise_has_users", ["users_id"], name: "users_id", using: :btree

  create_table "in_innovation_index", force: :cascade do |t|
    t.string   "name",     limit: 100
    t.string   "slug",     limit: 100
    t.integer  "status",   limit: 1,   default: 1
    t.integer  "add_by",   limit: 1,   default: 1
    t.integer  "added_by", limit: 4,   default: 1
    t.datetime "created"
    t.datetime "modified"
  end

  create_table "in_innovation_log", force: :cascade do |t|
    t.string   "title",       limit: 255,               null: false
    t.text     "description", limit: 65535,             null: false
    t.integer  "ischecked",   limit: 1,                 null: false
    t.integer  "users_id",    limit: 4,                 null: false
    t.integer  "from_user",   limit: 4,     default: 1, null: false
    t.string   "url",         limit: 255,               null: false
    t.datetime "created",                               null: false
    t.datetime "modified",                              null: false
  end

  add_index "in_innovation_log", ["from_user"], name: "from_user", using: :btree
  add_index "in_innovation_log", ["users_id"], name: "users_id", using: :btree

  create_table "in_post_has_comment_has_upvotes", force: :cascade do |t|
    t.integer "users_has_post_has_comments_id", limit: 4, null: false
    t.integer "users_id",                       limit: 4, null: false
  end

  add_index "in_post_has_comment_has_upvotes", ["users_id", "users_has_post_has_comments_id"], name: "fk_post_has_comment_has_upvotes_users1_idx", using: :btree

  create_table "in_post_has_comments", force: :cascade do |t|
    t.integer  "users_id",           limit: 4,                 null: false
    t.integer  "users_has_posts_id", limit: 4,                 null: false
    t.text     "description",        limit: 65535
    t.string   "image",              limit: 255,               null: false
    t.integer  "status",             limit: 1,     default: 1, null: false
    t.datetime "created",                                      null: false
    t.datetime "modified",                                     null: false
  end

  add_index "in_post_has_comments", ["users_has_posts_id"], name: "fk_users_has_post_has_comments_users_has_posts1_idx", using: :btree
  add_index "in_post_has_comments", ["users_id"], name: "fk_users_has_post_has_comments_users1_idx", using: :btree

  create_table "in_post_has_index", force: :cascade do |t|
    t.integer  "in_users_has_posts_id",  limit: 4,             null: false
    t.integer  "in_innovation_index_id", limit: 4,             null: false
    t.integer  "status",                 limit: 1, default: 1
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_post_has_index", ["in_innovation_index_id"], name: "fk_in_post_has_index_in_innovation_index1_idx", using: :btree
  add_index "in_post_has_index", ["in_users_has_posts_id"], name: "fk_in_post_has_index_in_users_has_posts1_idx", using: :btree

  create_table "in_post_has_media", force: :cascade do |t|
    t.integer  "in_users_has_posts_id", limit: 4,   null: false
    t.string   "name",                  limit: 200
    t.string   "url",                   limit: 245, null: false
    t.string   "size",                  limit: 45
    t.string   "extension",             limit: 45
    t.string   "type",                  limit: 45
    t.string   "status",                limit: 45
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_post_has_media", ["in_users_has_posts_id"], name: "fk_in_post_has_media_in_users_has_posts1_idx", using: :btree

  create_table "in_post_has_reports", force: :cascade do |t|
    t.integer  "in_users_has_posts_id", limit: 4,              null: false
    t.integer  "in_user_enterprise_id", limit: 4
    t.integer  "users_id",              limit: 4,              null: false
    t.string   "reason",                limit: 45
    t.integer  "status",                limit: 1,  default: 1
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_post_has_reports", ["in_user_enterprise_id"], name: "in_user_enterprise_id", using: :btree
  add_index "in_post_has_reports", ["in_users_has_posts_id"], name: "fk_in_post_has_flag_in_users_has_posts1_idx", using: :btree
  add_index "in_post_has_reports", ["users_id"], name: "fk_in_post_has_flag_users1_idx", using: :btree

  create_table "in_post_has_shares", force: :cascade do |t|
    t.integer "users_has_posts_id", limit: 4,  null: false
    t.integer "users_id",           limit: 4,  null: false
    t.string  "type",               limit: 10
  end

  add_index "in_post_has_shares", ["users_has_posts_id"], name: "fk_post_has_shares_users_has_posts1_idx", using: :btree
  add_index "in_post_has_shares", ["users_id"], name: "fk_post_has_shares_users1_idx", using: :btree

  create_table "in_post_has_upvote", force: :cascade do |t|
    t.integer  "users_has_posts_id", limit: 4, null: false
    t.integer  "users_id",           limit: 4, null: false
    t.datetime "created",                      null: false
    t.datetime "modified",                     null: false
  end

  add_index "in_post_has_upvote", ["users_has_posts_id"], name: "fk_upvotes_has_in_user_has_post_id", using: :btree
  add_index "in_post_has_upvote", ["users_id"], name: "fk_post_has_upvote_users1_idx", using: :btree

  create_table "in_post_has_users", force: :cascade do |t|
    t.integer  "status",                limit: 1, default: 1
    t.datetime "created"
    t.datetime "modified"
    t.integer  "in_users_has_posts_id", limit: 4,             null: false
    t.integer  "users_id",              limit: 4,             null: false
    t.integer  "is_notification",       limit: 1,             null: false
  end

  add_index "in_post_has_users", ["in_users_has_posts_id"], name: "fk_in_post_has_users_in_users_has_posts1_idx", using: :btree
  add_index "in_post_has_users", ["users_id"], name: "fk_in_post_has_users_users1_idx", using: :btree

  create_table "in_role", force: :cascade do |t|
    t.string "name", limit: 50
  end

  create_table "in_top_index_user", force: :cascade do |t|
    t.integer "in_innovation_index_id", limit: 4, null: false
    t.integer "in_enterprise_id",       limit: 4
    t.integer "users_id",               limit: 4, null: false
    t.integer "total_count",            limit: 4
  end

  add_index "in_top_index_user", ["in_enterprise_id"], name: "in_enterprise_id", using: :btree
  add_index "in_top_index_user", ["in_innovation_index_id"], name: "in_innovation_index", using: :btree
  add_index "in_top_index_user", ["users_id"], name: "in_users_index", using: :btree

  create_table "in_users_has_enterprise", force: :cascade do |t|
    t.string   "designation",    limit: 100
    t.string   "sub_domain",     limit: 100
    t.integer  "users_id",       limit: 4,               null: false
    t.string   "company_domain", limit: 100
    t.integer  "status",         limit: 1,   default: 1
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_users_has_enterprise", ["users_id"], name: "fk_in_users_has_profile_users1_idx", using: :btree

  create_table "in_users_has_index", force: :cascade do |t|
    t.integer  "users_id",               limit: 4,             null: false
    t.integer  "in_innovation_index_id", limit: 4,             null: false
    t.integer  "in_user_enterprise_id",  limit: 4
    t.integer  "status",                 limit: 1, default: 1
    t.integer  "notification_status",    limit: 1, default: 1
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_users_has_index", ["in_innovation_index_id"], name: "fk_in_users_has_index_in_innovation_index1_idx", using: :btree
  add_index "in_users_has_index", ["in_user_enterprise_id"], name: "in_user_enterprise_id", using: :btree
  add_index "in_users_has_index", ["users_id"], name: "fk_in_users_has_index_users1_idx", using: :btree

  create_table "in_users_has_posts", force: :cascade do |t|
    t.integer  "users_id",              limit: 4,                 null: false
    t.string   "slug",                  limit: 255,               null: false
    t.integer  "is_deleted",            limit: 1,     default: 0, null: false
    t.integer  "in_user_enterprise_id", limit: 4,     default: 1, null: false
    t.string   "title",                 limit: 255
    t.text     "description",           limit: 65535
    t.text     "website",               limit: 65535
    t.integer  "status",                limit: 1,     default: 1
    t.datetime "created"
    t.datetime "modified"
  end

  add_index "in_users_has_posts", ["in_user_enterprise_id"], name: "in_user_enterprise_id", using: :btree
  add_index "in_users_has_posts", ["slug"], name: "slug", using: :btree
  add_index "in_users_has_posts", ["users_id"], name: "fk_posts_users1_idx", using: :btree

  create_table "industries", force: :cascade do |t|
    t.string  "name",        limit: 45
    t.string  "description", limit: 245
    t.string  "position",    limit: 45
    t.integer "status",      limit: 1
  end

  create_table "linkedin_connections", force: :cascade do |t|
    t.string   "linkedin_Id", limit: 100, null: false
    t.string   "first_name",  limit: 45
    t.string   "last_name",   limit: 45
    t.string   "headline",    limit: 245
    t.string   "image",       limit: 255
    t.string   "industry",    limit: 245
    t.string   "location",    limit: 100
    t.string   "url",         limit: 245
    t.datetime "add_date"
    t.integer  "status",      limit: 1
    t.integer  "cities_id",   limit: 4,   null: false
    t.integer  "users_id",    limit: 4,   null: false
  end

  add_index "linkedin_connections", ["cities_id"], name: "fk_linkedin_connections_cities1_idx", using: :btree
  add_index "linkedin_connections", ["users_id"], name: "fk_linkedin_connections_users1_idx", using: :btree

  create_table "log", force: :cascade do |t|
    t.integer  "proposal_id",    limit: 4
    t.integer  "project_status", limit: 4
    t.integer  "is_checked",     limit: 1
    t.text     "title",          limit: 65535
    t.text     "description",    limit: 65535
    t.datetime "add_date"
    t.datetime "update_date"
    t.integer  "status",         limit: 1
    t.integer  "for_user",       limit: 4
    t.integer  "notification",   limit: 1
    t.integer  "is_read",        limit: 1
    t.integer  "is_active",      limit: 1
    t.integer  "login_id",       limit: 4,                 null: false
    t.integer  "is_prior_admin", limit: 1,     default: 0, null: false
    t.integer  "admin_seenby",   limit: 4
  end

  add_index "log", ["login_id"], name: "fk_log_users1_idx", using: :btree

  create_table "milestone_status", force: :cascade do |t|
    t.string   "title",       limit: 100, null: false
    t.string   "image",       limit: 150
    t.string   "description", limit: 500, null: false
    t.datetime "add_date",                null: false
    t.integer  "status",      limit: 1,   null: false
  end

  create_table "milestones_has_log", force: :cascade do |t|
    t.integer  "supplier_milestones_id", limit: 4,                 null: false
    t.integer  "users_id",               limit: 4
    t.text     "old_text",               limit: 65535
    t.text     "new_text",               limit: 65535
    t.datetime "add_date"
    t.text     "note",                   limit: 65535
    t.integer  "status",                 limit: 1,     default: 1, null: false
  end

  add_index "milestones_has_log", ["supplier_milestones_id"], name: "fk_milestones_has_order_status_supplier_has_milestones1_idx", using: :btree

  create_table "milestones_has_order_status", force: :cascade do |t|
    t.integer  "supplier_milestones_id", limit: 4,     null: false
    t.integer  "old_status",             limit: 1
    t.integer  "new_status",             limit: 1
    t.datetime "date"
    t.text     "note",                   limit: 65535
  end

  add_index "milestones_has_order_status", ["supplier_milestones_id"], name: "fk_milestones_has_order_status_supplier_has_milestones1_idx", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "status",   limit: 1
    t.string   "message",  limit: 245
    t.datetime "add_date"
    t.integer  "is_read",  limit: 1
    t.integer  "users_id", limit: 4,   null: false
    t.integer  "log_id",   limit: 4
  end

  add_index "notifications", ["users_id"], name: "fk_notifications_users1_idx", using: :btree

  create_table "office_type", force: :cascade do |t|
    t.string   "name",        limit: 250
    t.string   "description", limit: 500
    t.integer  "status",      limit: 1,   default: 1, null: false
    t.datetime "add_date"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "users_id",             limit: 4,                 null: false
    t.string   "payment_method_type",  limit: 255
    t.string   "oauth_token",          limit: 255
    t.string   "refreash_token",       limit: 255
    t.string   "synapse_user_id",      limit: 255
    t.string   "synapse_node_id",      limit: 255
    t.string   "synapse_node_type",    limit: 255
    t.string   "paysimple_user_id",    limit: 255
    t.string   "paysimple_payment_id", limit: 255
    t.string   "stripe_user_id",       limit: 255
    t.string   "fingerprint",          limit: 255
    t.integer  "is_kyc",               limit: 4,     default: 0, null: false
    t.integer  "is_business_kyc",      limit: 1,     default: 0, null: false
    t.integer  "is_bank_linked",       limit: 4,     default: 0, null: false
    t.text     "note",                 limit: 65535
    t.text     "comment",              limit: 65535
    t.integer  "status",               limit: 1,     default: 1, null: false
    t.datetime "add_date"
    t.datetime "mod_date"
  end

  add_index "payments", ["users_id"], name: "users_id", using: :btree

  create_table "paysimple_payment", force: :cascade do |t|
    t.integer  "users_id",               limit: 4,                 null: false
    t.string   "paysimple_user_id",      limit: 255
    t.string   "paysimple_payment_id",   limit: 255
    t.string   "paysimple_payment_type", limit: 255
    t.integer  "is_bank_linked",         limit: 4,     default: 0, null: false
    t.text     "note",                   limit: 65535
    t.text     "comment",                limit: 65535
    t.integer  "status",                 limit: 4,     default: 1, null: false
    t.datetime "add_date"
    t.datetime "mod_date"
  end

  add_index "paysimple_payment", ["users_id"], name: "users_id", using: :btree

  create_table "pitch_has_milestones", force: :cascade do |t|
    t.text     "title",               limit: 65535
    t.text     "overview",            limit: 65535
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "due_date"
    t.float    "amount",              limit: 53
    t.string   "vp_cut",              limit: 50,    default: "0", null: false
    t.text     "note",                limit: 65535
    t.integer  "is_schedule_payment", limit: 1,     default: 0
    t.string   "transaction",         limit: 100
    t.integer  "is_settled",          limit: 4,     default: 0,   null: false
    t.datetime "add_date"
    t.datetime "modify_date"
    t.integer  "is_flagged",          limit: 1,     default: 0,   null: false
    t.integer  "status",              limit: 4
    t.integer  "proposal_pitches_id", limit: 4,                   null: false
    t.integer  "users_id",            limit: 4,                   null: false
    t.integer  "is_final",            limit: 1,     default: 0,   null: false
    t.string   "performance",         limit: 50
  end

  add_index "pitch_has_milestones", ["proposal_pitches_id"], name: "fk_supplier_has_milestones_proposal_pitches_idx", using: :btree
  add_index "pitch_has_milestones", ["status"], name: "status", using: :btree
  add_index "pitch_has_milestones", ["users_id"], name: "fk_pitch_has_milestones_users_idx", using: :btree

  create_table "price_tier", force: :cascade do |t|
    t.string  "title",         limit: 45
    t.text    "description",   limit: 65535
    t.string  "min_price",     limit: 45
    t.string  "max_price",     limit: 45
    t.string  "d_min_price",   limit: 45
    t.string  "d_max_price",   limit: 45
    t.text    "d_description", limit: 65535
    t.integer "price_zone",    limit: 4
    t.integer "status",        limit: 1
    t.integer "price_zone_id", limit: 4,     null: false
  end

  add_index "price_tier", ["price_zone_id"], name: "fk_price_tier_price_zone1_idx", using: :btree

  create_table "price_zone", force: :cascade do |t|
    t.string  "min_price",   limit: 45
    t.string  "max_price",   limit: 45
    t.string  "title",       limit: 500
    t.text    "description", limit: 65535
    t.integer "status",      limit: 1
  end

  create_table "project_references", force: :cascade do |t|
    t.string   "name",               limit: 45
    t.string   "link",               limit: 45
    t.string   "details",            limit: 545
    t.datetime "add_date"
    t.integer  "status",             limit: 1
    t.integer  "client_projects_id", limit: 4,   null: false
    t.string   "reference_number",   limit: 45
  end

  add_index "project_references", ["client_projects_id"], name: "fk_project_references_client_projects1_idx", using: :btree

  create_table "proposal_documents", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "path",         limit: 255
    t.string   "extention",    limit: 45
    t.string   "size",         limit: 45
    t.string   "type",         limit: 45
    t.datetime "add_date"
    t.integer  "status",       limit: 1
    t.integer  "proposals_id", limit: 4,   null: false
  end

  add_index "proposal_documents", ["proposals_id"], name: "fk_proposal_documents_proposals1_idx", using: :btree

  create_table "proposal_pitches", force: :cascade do |t|
    t.integer  "billing_type",             limit: 1
    t.integer  "tm_billing_schedule_type", limit: 1
    t.string   "tm_amount",                limit: 45
    t.string   "fp_total_price",           limit: 45
    t.integer  "fp_total_price_interval",  limit: 1
    t.string   "duration",                 limit: 45
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "clent_contract_link",      limit: 500
    t.string   "trial",                    limit: 45
    t.datetime "add_date"
    t.integer  "status",                   limit: 1
    t.text     "remarks",                  limit: 65535
    t.text     "client_note",              limit: 65535
    t.text     "client_comment",           limit: 65535
    t.text     "notes",                    limit: 65535
    t.text     "admin_note",               limit: 65535
    t.integer  "users_id",                 limit: 4,                 null: false
    t.integer  "suppliers_projects_id",    limit: 4,                 null: false
    t.integer  "is_viewed",                limit: 1,     default: 0, null: false
  end

  add_index "proposal_pitches", ["suppliers_projects_id"], name: "fk_proposal_pitches_suppliers_projects1_idx", using: :btree
  add_index "proposal_pitches", ["users_id"], name: "fk_proposal_pitches_users1_idx", using: :btree

  create_table "ref_projects_terms", force: :cascade do |t|
    t.integer  "client_projects_id", limit: 4,             null: false
    t.integer  "vp_profit",          limit: 4
    t.integer  "signup_benefit",     limit: 4
    t.integer  "client_benefit",     limit: 4
    t.integer  "supplier_benefit",   limit: 4
    t.integer  "spent_amount",       limit: 4
    t.datetime "modify_date"
    t.datetime "add_date",                                 null: false
    t.integer  "status",             limit: 1, default: 1, null: false
    t.integer  "added_by",           limit: 4
    t.integer  "last_updated_by",    limit: 4
  end

  add_index "ref_projects_terms", ["client_projects_id"], name: "client_projects_id", using: :btree

  create_table "ref_redeem_benefit", force: :cascade do |t|
    t.integer  "ref_transaction_id", limit: 4,                 null: false
    t.text     "title",              limit: 65535
    t.text     "description",        limit: 65535
    t.text     "note",               limit: 65535
    t.text     "comments",           limit: 65535
    t.datetime "add_date",                                     null: false
    t.datetime "modify_date"
    t.integer  "status",             limit: 1,     default: 1, null: false
  end

  add_index "ref_redeem_benefit", ["ref_transaction_id"], name: "ref_transaction_id", using: :btree

  create_table "ref_settings", force: :cascade do |t|
    t.integer  "vp_profit",        limit: 4
    t.integer  "signup_benefit",   limit: 4
    t.integer  "client_benefit",   limit: 4
    t.integer  "supplier_benefit", limit: 4
    t.integer  "spent_amount",     limit: 4
    t.text     "detials",          limit: 65535
    t.text     "note",             limit: 65535
    t.text     "comments",         limit: 65535
    t.datetime "modify_date"
    t.datetime "add_date"
    t.integer  "status",           limit: 1,     default: 1, null: false
  end

  create_table "ref_transaction", force: :cascade do |t|
    t.integer  "ref_wallet_id",    limit: 4,                 null: false
    t.integer  "amount",           limit: 8,     default: 0, null: false
    t.string   "title",            limit: 500
    t.text     "description",      limit: 65535
    t.text     "note",             limit: 65535
    t.text     "comments",         limit: 65535
    t.integer  "transaction_type", limit: 4,                 null: false
    t.integer  "users_role",       limit: 4,                 null: false
    t.datetime "add_date",                                   null: false
    t.datetime "modify_date"
    t.integer  "status",           limit: 1,     default: 1, null: false
  end

  add_index "ref_transaction", ["ref_wallet_id", "users_role"], name: "ref_wallet_id", using: :btree
  add_index "ref_transaction", ["users_role"], name: "users_role", using: :btree

  create_table "ref_wallet", force: :cascade do |t|
    t.integer  "users_id",      limit: 4,                 null: false
    t.integer  "c_amount",      limit: 8,     default: 0, null: false
    t.integer  "s_amount",      limit: 8,     default: 0, null: false
    t.integer  "signup_amount", limit: 4
    t.integer  "is_redeemed",   limit: 1,     default: 0, null: false
    t.text     "note",          limit: 65535
    t.text     "comments",      limit: 65535
    t.datetime "add_date",                                null: false
    t.datetime "modify_date"
    t.integer  "status",        limit: 1,     default: 1, null: false
  end

  add_index "ref_wallet", ["users_id"], name: "users_id", using: :btree

  create_table "referral", force: :cascade do |t|
    t.integer  "referral_id",      limit: 4,                     null: false
    t.integer  "referance_id",     limit: 4,                     null: false
    t.integer  "referral_type",    limit: 4,     default: 1,     null: false
    t.integer  "users_role",       limit: 4,                     null: false
    t.integer  "vp_profit",        limit: 4,     default: 10,    null: false
    t.integer  "signup_benefit",   limit: 4,     default: 500,   null: false
    t.integer  "client_benefit",   limit: 4,     default: 500,   null: false
    t.integer  "supplier_benefit", limit: 4,     default: 10,    null: false
    t.integer  "spent_amount",     limit: 4,     default: 10000, null: false
    t.integer  "inhaled",          limit: 1,     default: 0,     null: false
    t.text     "note",             limit: 65535
    t.text     "comments",         limit: 65535
    t.text     "details",          limit: 65535
    t.datetime "add_date",                                       null: false
    t.datetime "modify_date"
    t.integer  "status",           limit: 1,     default: 1,     null: false
  end

  add_index "referral", ["referance_id"], name: "referance_id", using: :btree
  add_index "referral", ["referral_id"], name: "referral_id", using: :btree
  add_index "referral", ["users_role"], name: "users_role", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string  "name",        limit: 245
    t.integer "description", limit: 4
    t.string  "code",        limit: 10
    t.string  "code2",       limit: 10
    t.integer "status",      limit: 1
  end

  create_table "repo_category_stats", force: :cascade do |t|
    t.integer  "issues_count",             limit: 4
    t.integer  "version",                  limit: 4
    t.integer  "supplier_project_repo_id", limit: 4
    t.integer  "code_category_id",         limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "repo_category_stats", ["code_category_id"], name: "index_repo_category_stats_on_code_category_id", using: :btree
  add_index "repo_category_stats", ["supplier_project_repo_id"], name: "index_repo_category_stats_on_supplier_project_repo_id", using: :btree

  create_table "review_category", force: :cascade do |t|
    t.string   "name",        limit: 100
    t.text     "description", limit: 65535
    t.datetime "add_date"
    t.integer  "status",      limit: 1,     default: 1
  end

  create_table "review_questions", force: :cascade do |t|
    t.string   "title",              limit: 450
    t.text     "description",        limit: 65535
    t.datetime "add_date"
    t.integer  "status",             limit: 1,     default: 1
    t.integer  "review_category_id", limit: 4,                 null: false
  end

  add_index "review_questions", ["review_category_id"], name: "fk_review_questions_review_category1_idx", using: :btree

  create_table "role", force: :cascade do |t|
    t.string   "name",        limit: 45
    t.string   "description", limit: 500
    t.datetime "add_date"
    t.integer  "status",      limit: 1
  end

  create_table "search_criteria", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,                 null: false
    t.integer  "project_id",  limit: 4
    t.string   "skills",      limit: 500
    t.string   "industry",    limit: 500
    t.string   "location",    limit: 500
    t.string   "price_range", limit: 200
    t.text     "comments",    limit: 65535
    t.datetime "add_date"
    t.integer  "status",      limit: 1,     default: 1
    t.string   "services",    limit: 500
  end

  add_index "search_criteria", ["user_id"], name: "user_id", using: :btree

  create_table "sendgrid_response", force: :cascade do |t|
    t.text     "response",       limit: 65535,             null: false
    t.text     "headers",        limit: 65535
    t.text     "mail_to",        limit: 65535
    t.text     "dkim",           limit: 65535
    t.text     "html",           limit: 65535
    t.text     "mail_from",      limit: 65535
    t.text     "text",           limit: 65535
    t.text     "subject",        limit: 65535
    t.text     "sender_ip",      limit: 65535
    t.text     "envelope",       limit: 65535
    t.text     "attachments",    limit: 65535
    t.datetime "add_date"
    t.integer  "is_attachments", limit: 1,     default: 0
    t.string   "remarks",        limit: 245
  end

  create_table "services", force: :cascade do |t|
    t.string  "name",        limit: 45
    t.string  "description", limit: 255
    t.string  "tooltip",     limit: 255
    t.string  "category",    limit: 45
    t.integer "status",      limit: 1
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 500
    t.integer  "skillcol",    limit: 1
    t.datetime "add_date"
    t.integer  "parent_id",   limit: 4,   default: 0
  end

  create_table "status", force: :cascade do |t|
    t.string   "title",       limit: 45
    t.string   "description", limit: 500
    t.datetime "add_date"
    t.integer  "publish",     limit: 1
  end

  create_table "supplier_documents", force: :cascade do |t|
    t.integer  "suppliers_propsal_id", limit: 4
    t.string   "name",                 limit: 500
    t.string   "path",                 limit: 500
    t.string   "extension",            limit: 45
    t.string   "size",                 limit: 45
    t.string   "type",                 limit: 45
    t.integer  "status",               limit: 1
    t.datetime "add_date"
  end

  create_table "supplier_has_milestones", force: :cascade do |t|
    t.text     "module",               limit: 65535
    t.date     "start_date"
    t.date     "end_date"
    t.float    "amount",               limit: 53
    t.datetime "date"
    t.integer  "status",               limit: 4
    t.string   "transaction",          limit: 100
    t.text     "note",                 limit: 65535
    t.date     "reminder_date"
    t.string   "milestone_title",      limit: 100
    t.text     "overview",             limit: 65535
    t.datetime "due_date"
    t.integer  "is_schedule_payment",  limit: 1
    t.integer  "suppliers_id",         limit: 4,     null: false
    t.integer  "supplier_proposal_id", limit: 4
  end

  add_index "supplier_has_milestones", ["suppliers_id"], name: "fk_supplier_has_milestones_suppliers1_idx", using: :btree

  create_table "supplier_project_repos", force: :cascade do |t|
    t.string   "username",            limit: 255
    t.string   "repo_name",           limit: 255
    t.string   "clone_url",           limit: 255
    t.string   "clone_path",          limit: 255
    t.string   "default_branch",      limit: 255
    t.string   "current_branch",      limit: 255
    t.string   "gpa",                 limit: 255
    t.integer  "analysis_status",     limit: 4
    t.integer  "status",              limit: 4
    t.integer  "supplier_project_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "first_name",                 limit: 250
    t.string   "last_name",                  limit: 250
    t.string   "cover",                      limit: 500
    t.integer  "client_views",               limit: 8,     default: 0,   null: false
    t.string   "image",                      limit: 500
    t.string   "email",                      limit: 45
    t.string   "skype_id",                   limit: 45
    t.string   "website",                    limit: 45
    t.string   "phone_number",               limit: 45
    t.string   "tagline",                    limit: 45
    t.text     "about_company",              limit: 65535
    t.string   "foundation_year",            limit: 10
    t.string   "short_description",          limit: 300
    t.text     "details",                    limit: 65535
    t.string   "location",                   limit: 45
    t.string   "pricing_details",            limit: 500
    t.string   "min_price",                  limit: 100
    t.string   "number_of_employee",         limit: 20
    t.string   "total_available_employee",   limit: 20
    t.text     "consultation_description",   limit: 65535
    t.string   "standard_pitch",             limit: 255
    t.string   "standard_service_agreement", limit: 255
    t.integer  "profile_status",             limit: 4
    t.datetime "add_date"
    t.datetime "modification_date"
    t.text     "rough_estimate",             limit: 65535
    t.string   "linkedin",                   limit: 200
    t.string   "facebook",                   limit: 200
    t.string   "google",                     limit: 200
    t.string   "twitter",                    limit: 200
    t.string   "you_tube",                   limit: 100
    t.integer  "per_hour_rate_from",         limit: 4
    t.integer  "per_hour_rate_to",           limit: 4
    t.integer  "per_hour_rate",              limit: 4
    t.string   "project_size",               limit: 45
    t.string   "web_references",             limit: 490
    t.string   "development_location",       limit: 490
    t.string   "sales_location",             limit: 490
    t.string   "response_time",              limit: 20
    t.integer  "is_faq_completed",           limit: 1
    t.integer  "is_admin_approve",           limit: 1
    t.text     "signature",                  limit: 65535
    t.integer  "status",                     limit: 1
    t.integer  "users_id",                   limit: 4,                   null: false
    t.string   "logo",                       limit: 100
    t.integer  "manager_prefer",             limit: 1,     default: 0
    t.integer  "dev_prefer",                 limit: 1,     default: 0
    t.integer  "unknown_prefer",             limit: 1,     default: 0
    t.integer  "pref_four",                  limit: 1,     default: 0,   null: false
    t.text     "default_q1_ans",             limit: 65535
    t.integer  "is_invited",                 limit: 4,     default: 0
    t.datetime "accept_new_project_date"
    t.integer  "is_profile_complete",        limit: 1
    t.integer  "price_tier_id",              limit: 4
    t.string   "payoneer_payee",             limit: 145
    t.string   "payoneer_token",             limit: 145
    t.integer  "link_status",                limit: 1
    t.string   "offers",                     limit: 300
    t.integer  "vp_commission",              limit: 4,     default: 0
    t.string   "level",                      limit: 20,    default: "1", null: false
    t.datetime "profile_completed_date"
    t.datetime "admin_approved_date"
  end

  add_index "suppliers", ["users_id"], name: "fk_suppliers_users1_idx", using: :btree

  create_table "suppliers_faq_answers", force: :cascade do |t|
    t.integer  "suppliers_id", limit: 4,     null: false
    t.integer  "faq_id",       limit: 4,     null: false
    t.integer  "status",       limit: 1
    t.datetime "add_date"
    t.text     "answer",       limit: 65535
    t.integer  "publish",      limit: 1
  end

  add_index "suppliers_faq_answers", ["faq_id"], name: "fk_suppliers_has_faq_faq1_idx", using: :btree
  add_index "suppliers_faq_answers", ["suppliers_id"], name: "fk_suppliers_has_faq_suppliers1_idx", using: :btree

  create_table "suppliers_has_awards", force: :cascade do |t|
    t.integer "suppliers_id", limit: 4,     null: false
    t.string  "title",        limit: 100,   null: false
    t.text    "description",  limit: 65535, null: false
    t.string  "image",        limit: 100
  end

  create_table "suppliers_has_category_rating", force: :cascade do |t|
    t.integer  "suppliers_has_references_id", limit: 4,  null: false
    t.integer  "review_category_id",          limit: 4,  null: false
    t.string   "rating",                      limit: 45
    t.datetime "add_date"
    t.integer  "status",                      limit: 1
  end

  add_index "suppliers_has_category_rating", ["review_category_id"], name: "fk_suppliers_has_references_has_review_category_review_cate_idx", using: :btree
  add_index "suppliers_has_category_rating", ["suppliers_has_references_id"], name: "fk_suppliers_has_references_has_review_category_suppliers_h_idx", using: :btree

  create_table "suppliers_has_cities", force: :cascade do |t|
    t.integer  "suppliers_id", limit: 4,             null: false
    t.integer  "cities_id",    limit: 4,             null: false
    t.integer  "is_main",      limit: 1, default: 0
    t.datetime "add_date"
    t.integer  "status",       limit: 1
  end

  add_index "suppliers_has_cities", ["cities_id"], name: "fk_suppliers_has_cities_cities1_idx", using: :btree
  add_index "suppliers_has_cities", ["suppliers_id"], name: "fk_suppliers_has_cities_suppliers1_idx", using: :btree

  create_table "suppliers_has_industries", force: :cascade do |t|
    t.integer  "suppliers_id",  limit: 4, null: false
    t.integer  "industries_id", limit: 4, null: false
    t.datetime "add_date"
    t.integer  "status",        limit: 1
  end

  add_index "suppliers_has_industries", ["industries_id"], name: "fk_suppliers_has_industries_industries1_idx", using: :btree
  add_index "suppliers_has_industries", ["suppliers_id"], name: "fk_suppliers_has_industries_suppliers1_idx", using: :btree

  create_table "suppliers_has_portfolio", force: :cascade do |t|
    t.integer  "suppliers_id",          limit: 4,                 null: false
    t.integer  "suppliers_projects_id", limit: 4
    t.string   "project_name",          limit: 250
    t.text     "project_link",          limit: 65535
    t.text     "description",           limit: 65535
    t.integer  "industry_id",           limit: 4
    t.integer  "service_id",            limit: 4
    t.string   "client_name",           limit: 100
    t.string   "year_done",             limit: 45
    t.date     "start_date"
    t.date     "modify_date"
    t.string   "estimate_price",        limit: 100
    t.string   "estimate_timeline",     limit: 100
    t.string   "language_used",         limit: 250
    t.string   "cover",                 limit: 500
    t.datetime "add_date"
    t.integer  "status",                limit: 1
    t.integer  "portfolio_type",        limit: 1
    t.string   "one_line_pitch",        limit: 250
    t.string   "who_can",               limit: 250
    t.string   "markets",               limit: 250
    t.string   "portfolio_status",      limit: 20
    t.string   "no_of_customers",       limit: 20
    t.string   "launched_in",           limit: 20
    t.string   "no_of_users",           limit: 20
    t.string   "deployment",            limit: 20
    t.integer  "is_free_trial",         limit: 1
    t.string   "project_size",          limit: 100
    t.string   "per_hour_rate",         limit: 20
    t.string   "platform",              limit: 250
    t.string   "company_name",          limit: 50
    t.integer  "is_discreet",           limit: 1
    t.string   "discreet_desc",         limit: 100
    t.integer  "location",              limit: 4
    t.string   "image",                 limit: 100
    t.integer  "order",                 limit: 1,     default: 0
  end

  add_index "suppliers_has_portfolio", ["suppliers_id"], name: "fk_suppliers_portfolio_suppliers1_idx", using: :btree

  create_table "suppliers_has_portfolio_has_services", force: :cascade do |t|
    t.integer  "suppliers_has_portfolio_id", limit: 4, null: false
    t.integer  "services_id",                limit: 4, null: false
    t.datetime "add_date"
    t.integer  "status",                     limit: 1
  end

  add_index "suppliers_has_portfolio_has_services", ["services_id"], name: "fk_suppliers_has_portfolio_has_services_services1_idx", using: :btree
  add_index "suppliers_has_portfolio_has_services", ["suppliers_has_portfolio_id"], name: "fk_suppliers_has_portfolio_has_services_suppliers_has_portf_idx", using: :btree

  create_table "suppliers_has_portfolio_has_skills", force: :cascade do |t|
    t.integer  "suppliers_has_portfolio_id", limit: 4, null: false
    t.integer  "skills_id",                  limit: 4, null: false
    t.datetime "add_date"
    t.integer  "status",                     limit: 1
  end

  add_index "suppliers_has_portfolio_has_skills", ["skills_id"], name: "fk_suppliers_has_portfolio_has_skills_skills1_idx", using: :btree
  add_index "suppliers_has_portfolio_has_skills", ["suppliers_has_portfolio_id"], name: "fk_suppliers_has_portfolio_has_skills_suppliers_has_portfol_idx", using: :btree

  create_table "suppliers_has_references", force: :cascade do |t|
    t.string   "project_name",               limit: 100
    t.text     "project_description",        limit: 65535
    t.string   "company_name",               limit: 45
    t.string   "client_email",               limit: 45
    t.string   "year_engagement",            limit: 45
    t.boolean  "is_published",                             default: false
    t.integer  "skill_rating",               limit: 4
    t.integer  "timeline_rating",            limit: 4
    t.integer  "independence_rating",        limit: 4
    t.text     "provide_do_well",            limit: 65535
    t.text     "provider_improve",           limit: 65535
    t.text     "tag_line",                   limit: 65535
    t.datetime "add_date"
    t.datetime "modified"
    t.integer  "suppliers_id",               limit: 4,                     null: false
    t.integer  "client_profiles_id",         limit: 4,                     null: false
    t.integer  "suppliers_has_portfolio_id", limit: 4,                     null: false
    t.string   "client_first_name",          limit: 45
    t.string   "client_last_name",           limit: 45
    t.integer  "follow_venturepact",         limit: 1
    t.integer  "is_unattributed",            limit: 1
    t.integer  "email_hide",                 limit: 1
    t.boolean  "review_type",                              default: false
    t.integer  "status",                     limit: 1,     default: 0,     null: false
  end

  add_index "suppliers_has_references", ["client_profiles_id"], name: "fk_suppliers_has_references_client_profiles1_idx", using: :btree
  add_index "suppliers_has_references", ["suppliers_has_portfolio_id"], name: "suppliers_has_references_ibfk_1", using: :btree
  add_index "suppliers_has_references", ["suppliers_id"], name: "fk_suppliers_references_suppliers1_idx", using: :btree

  create_table "suppliers_has_services", force: :cascade do |t|
    t.integer  "suppliers_id", limit: 4, null: false
    t.integer  "services_id",  limit: 4, null: false
    t.datetime "add_date"
    t.integer  "status",       limit: 1
  end

  add_index "suppliers_has_services", ["services_id"], name: "fk_suppliers_has_services1_services1_idx", using: :btree
  add_index "suppliers_has_services", ["suppliers_id"], name: "fk_suppliers_has_services1_suppliers1_idx", using: :btree

  create_table "suppliers_has_skills", force: :cascade do |t|
    t.integer  "suppliers_id", limit: 4, null: false
    t.integer  "skills_id",    limit: 4, null: false
    t.datetime "add_date"
    t.integer  "status",       limit: 1
  end

  add_index "suppliers_has_skills", ["skills_id"], name: "fk_suppliers_has_skills1_skills1_idx", using: :btree
  add_index "suppliers_has_skills", ["suppliers_id"], name: "fk_suppliers_has_skills1_suppliers1_idx", using: :btree

  create_table "suppliers_has_web", force: :cascade do |t|
    t.integer "suppliers_id", limit: 4,   null: false
    t.string  "social_site",  limit: 50
    t.string  "link",         limit: 200
  end

  create_table "suppliers_portfolio_has_industries", force: :cascade do |t|
    t.integer  "suppliers_has_portfolio_id", limit: 4, null: false
    t.integer  "industries_id",              limit: 4, null: false
    t.datetime "add_date"
    t.integer  "status",                     limit: 1
  end

  add_index "suppliers_portfolio_has_industries", ["industries_id"], name: "fk_suppliers_has_portfolio_has_industries_industries1_idx", using: :btree
  add_index "suppliers_portfolio_has_industries", ["suppliers_has_portfolio_id"], name: "fk_suppliers_has_portfolio_has_industries_suppliers_has_por_idx", using: :btree

  create_table "suppliers_portfolio_has_skills", force: :cascade do |t|
    t.integer  "portfolio_id", limit: 4
    t.integer  "skills_id",    limit: 4
    t.integer  "status",       limit: 1
    t.datetime "add_date"
  end

  create_table "suppliers_portfolio_has_team", force: :cascade do |t|
    t.integer  "suppliers_has_portfolio_id", limit: 4,   null: false
    t.string   "name",                       limit: 50
    t.string   "designation",                limit: 50
    t.string   "dep",                        limit: 50
    t.string   "image",                      limit: 150
    t.string   "linkedin",                   limit: 100
    t.string   "facebook",                   limit: 100
    t.string   "twitter",                    limit: 100
    t.datetime "add_date"
    t.integer  "status",                     limit: 1
  end

  add_index "suppliers_portfolio_has_team", ["suppliers_has_portfolio_id"], name: "fk_suppliers_portfolio_has_team_suppliers_has_portfolio1_idx", using: :btree

  create_table "suppliers_portfolio_images", force: :cascade do |t|
    t.integer  "suppliers_has_portfolio_id", limit: 4,     null: false
    t.string   "title",                      limit: 245
    t.string   "image",                      limit: 245
    t.text     "description",                limit: 65535
    t.datetime "add_date"
    t.integer  "status",                     limit: 1
  end

  add_index "suppliers_portfolio_images", ["suppliers_has_portfolio_id"], name: "fk_suppliers_portfolio_images_suppliers_has_portfolio1_idx", using: :btree

  create_table "suppliers_project_answer", force: :cascade do |t|
    t.integer  "question_id",  limit: 4
    t.integer  "suppliers_id", limit: 4
    t.text     "answer",       limit: 65535
    t.datetime "created"
  end

  create_table "suppliers_project_team", force: :cascade do |t|
    t.integer  "project_proposal_id", limit: 4
    t.string   "name",                limit: 250
    t.string   "description",         limit: 250
    t.string   "image",               limit: 250
    t.datetime "created"
    t.datetime "modified"
  end

  create_table "suppliers_projects", force: :cascade do |t|
    t.integer  "client_projects_id",     limit: 4,                 null: false
    t.integer  "suppliers_id",           limit: 4,                 null: false
    t.text     "pitch",                  limit: 65535
    t.text     "about_project",          limit: 65535
    t.text     "why_you",                limit: 65535
    t.string   "estimated_cost",         limit: 45
    t.string   "estimated_time",         limit: 45
    t.string   "trial_period",           limit: 45
    t.integer  "chat_room_id",           limit: 4,                 null: false
    t.text     "comments",               limit: 65535
    t.integer  "min_price",              limit: 4
    t.integer  "max_price",              limit: 4
    t.string   "time_material",          limit: 45
    t.string   "billing_schedule",       limit: 45
    t.date     "start_date"
    t.text     "note",                   limit: 65535
    t.integer  "is_escrow",              limit: 1
    t.string   "others",                 limit: 45
    t.datetime "add_date"
    t.integer  "status",                 limit: 1
    t.text     "modify_date",            limit: 65535
    t.text     "introduction_status",    limit: 65535
    t.integer  "supplier_message_count", limit: 4,     default: 0
    t.integer  "client_message_count",   limit: 4,     default: 0
    t.string   "first_response_diff",    limit: 50
    t.integer  "lead_score",             limit: 4,     default: 7
    t.integer  "is_archived",            limit: 4,     default: 0, null: false
    t.integer  "is_new_intro",           limit: 4,     default: 0, null: false
    t.integer  "admin_message_count",    limit: 4,     default: 0, null: false
    t.integer  "s_help",                 limit: 1,     default: 0, null: false
    t.integer  "c_help",                 limit: 1,     default: 0, null: false
    t.integer  "manager_id",             limit: 4
  end

  add_index "suppliers_projects", ["chat_room_id"], name: "chat_room_id", using: :btree
  add_index "suppliers_projects", ["client_projects_id"], name: "fk_proposals_client_projects1_idx", using: :btree
  add_index "suppliers_projects", ["manager_id"], name: "manager_id", using: :btree
  add_index "suppliers_projects", ["suppliers_id"], name: "supplier_id", using: :btree

  create_table "suppliers_references_questions", force: :cascade do |t|
    t.integer  "review_questions_id",         limit: 4,                 null: false
    t.integer  "suppliers_has_references_id", limit: 4,                 null: false
    t.text     "answers",                     limit: 65535
    t.string   "rating",                      limit: 45
    t.datetime "add_date"
    t.integer  "status",                      limit: 1,     default: 0
  end

  add_index "suppliers_references_questions", ["review_questions_id"], name: "fk_suppliers_has_references_has_review_questions_review_que_idx", using: :btree
  add_index "suppliers_references_questions", ["suppliers_has_references_id"], name: "fk_suppliers_has_references_has_review_questions_suppliers__idx", using: :btree

  create_table "suppliers_transactions", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "amount",      limit: 4
    t.text     "note",        limit: 65535
    t.text     "comments",    limit: 65535
    t.integer  "users_id",    limit: 4
    t.datetime "add_date"
    t.datetime "modify_date"
    t.integer  "status",      limit: 1,     default: 1
  end

  add_index "suppliers_transactions", ["users_id"], name: "users_id", using: :btree

  create_table "synapse_payment", force: :cascade do |t|
    t.integer  "users_id",        limit: 4,                 null: false
    t.string   "oauth_token",     limit: 255
    t.string   "refreash_token",  limit: 255
    t.string   "synapse_user_id", limit: 255
    t.string   "node_id",         limit: 255
    t.string   "node_type",       limit: 255
    t.string   "fingerprint",     limit: 255
    t.integer  "is_kyc",          limit: 4,     default: 0, null: false
    t.integer  "is_business_kyc", limit: 1,     default: 0, null: false
    t.integer  "is_bank_linked",  limit: 4,     default: 0, null: false
    t.text     "note",            limit: 65535
    t.text     "comment",         limit: 65535
    t.integer  "status",          limit: 4,     default: 1, null: false
    t.datetime "add_date"
    t.datetime "mod_date"
  end

  add_index "synapse_payment", ["users_id"], name: "users_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "tag_text",    limit: 200
    t.string   "tag_color",   limit: 200
    t.datetime "add_date"
    t.datetime "modify_date"
    t.string   "notes",       limit: 250
    t.string   "comments",    limit: 250
    t.integer  "status",      limit: 4,   default: 1, null: false
  end

  create_table "team", force: :cascade do |t|
    t.integer "add_by",           limit: 4,     null: false
    t.integer "users_id",         limit: 4,     null: false
    t.string  "first_name",       limit: 45
    t.string  "last_name",        limit: 45
    t.string  "about",            limit: 245
    t.string  "expertise_skills", limit: 245
    t.string  "education",        limit: 245
    t.text    "experiance",       limit: 65535
    t.date    "dob"
    t.string  "email",            limit: 45
    t.string  "phone",            limit: 25
    t.string  "skype",            limit: 25
    t.string  "image",            limit: 100
    t.string  "address",          limit: 250
    t.string  "pincode",          limit: 15
    t.integer "status",           limit: 1
    t.string  "type",             limit: 30
    t.string  "position",         limit: 45
    t.string  "linkedin",         limit: 100
    t.string  "google",           limit: 100
    t.string  "twitter",          limit: 100
    t.string  "facebook",         limit: 100
  end

  add_index "team", ["users_id"], name: "fk_team_users1_idx", using: :btree

  create_table "time_zone", force: :cascade do |t|
    t.string "country_code", limit: 2,  null: false
    t.string "name",         limit: 35, null: false
  end

  add_index "time_zone", ["name"], name: "idx_zone_name", using: :btree

  create_table "transaction_milestones", force: :cascade do |t|
    t.integer  "milestone_id",   limit: 4,             null: false
    t.integer  "transaction_id", limit: 4,             null: false
    t.datetime "add_date",                             null: false
    t.datetime "modify_date",                          null: false
    t.integer  "status",         limit: 1, default: 1, null: false
  end

  add_index "transaction_milestones", ["milestone_id", "transaction_id"], name: "milestone_id", using: :btree
  add_index "transaction_milestones", ["transaction_id"], name: "transaction_id", using: :btree

  create_table "update_logs", force: :cascade do |t|
    t.string   "username",    limit: 100
    t.string   "action",      limit: 30
    t.string   "controller",  limit: 45
    t.text     "description", limit: 65535
    t.string   "user_ip",     limit: 30
    t.datetime "datetime"
    t.integer  "user_id",     limit: 4
    t.integer  "updated_by",  limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "last_name",           limit: 45
    t.string   "first_name",          limit: 45
    t.string   "image",               limit: 245
    t.string   "company_name",        limit: 100
    t.string   "display_name",        limit: 100
    t.string   "username",            limit: 100
    t.string   "phone_number",        limit: 25
    t.string   "password",            limit: 255
    t.string   "linkedin",            limit: 200
    t.integer  "is_linkedin_user",    limit: 1,     default: 0, null: false
    t.string   "role",                limit: 45
    t.string   "time_zone",           limit: 100
    t.datetime "add_date"
    t.datetime "last_login"
    t.string   "last_login_location", limit: 100,               null: false
    t.text     "admin_notes",         limit: 65535
    t.integer  "status",              limit: 1
    t.integer  "role_id",             limit: 4,                 null: false
    t.string   "promo_code",          limit: 100,               null: false
    t.string   "access_token",        limit: 100
    t.integer  "is_innovation_user",  limit: 1,     default: 0
    t.integer  "is_in_invited",       limit: 1,     default: 0
    t.string   "google_access_token", limit: 500
    t.string   "github_access_token", limit: 500
  end

  add_index "users", ["display_name"], name: "display_name_UNIQUE", unique: true, using: :btree
  add_index "users", ["promo_code"], name: "promo_code", unique: true, using: :btree
  add_index "users", ["role_id"], name: "fk_users_role1_idx", using: :btree
  add_index "users", ["username"], name: "username_UNIQUE", unique: true, using: :btree

  create_table "users_has_cities", force: :cascade do |t|
    t.integer  "users_id",  limit: 4,               null: false
    t.integer  "cities_id", limit: 4,               null: false
    t.string   "details",   limit: 100
    t.integer  "is_main",   limit: 1,   default: 0, null: false
    t.datetime "add_date"
    t.integer  "status",    limit: 1,   default: 1
  end

  add_index "users_has_cities", ["cities_id"], name: "fk_users_has_cities_cities1_idx", using: :btree
  add_index "users_has_cities", ["users_id"], name: "fk_users_has_cities_users1_idx", using: :btree

  create_table "users_has_team", force: :cascade do |t|
    t.integer  "users_id", limit: 4, null: false
    t.integer  "team_id",  limit: 4, null: false
    t.integer  "status",   limit: 1
    t.datetime "add_date"
  end

  add_index "users_has_team", ["team_id"], name: "fk_users_has_team_team1_idx", using: :btree
  add_index "users_has_team", ["users_id"], name: "fk_users_has_team_users1_idx", using: :btree

  create_table "users_offices", force: :cascade do |t|
    t.integer  "user_id",  limit: 4,             null: false
    t.integer  "city_id",  limit: 4,             null: false
    t.integer  "dep_id",   limit: 4
    t.datetime "add_date"
    t.integer  "status",   limit: 4, default: 1
  end

  add_index "users_offices", ["city_id"], name: "city_id", using: :btree
  add_index "users_offices", ["dep_id"], name: "dep_id", using: :btree
  add_index "users_offices", ["user_id"], name: "user_id", using: :btree

  create_table "users_team_members", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,               null: false
    t.string   "name",        limit: 250
    t.string   "designation", limit: 250
    t.string   "dep",         limit: 250
    t.string   "linkedin",    limit: 500
    t.string   "facebook",    limit: 250
    t.string   "twitter",     limit: 100
    t.datetime "add_date"
    t.integer  "status",      limit: 1,   default: 1, null: false
    t.string   "image",       limit: 250
  end

  add_index "users_team_members", ["user_id"], name: "user_id", using: :btree

  create_table "zones", force: :cascade do |t|
    t.string  "name",        limit: 45
    t.string  "description", limit: 245
    t.string  "gmt",         limit: 45
    t.string  "save_hour",   limit: 10
    t.string  "zonescol",    limit: 45
    t.integer "status",      limit: 1
  end

  add_foreign_key "awards_certifications", "suppliers", column: "suppliers_id", name: "fk_awards_certifications_suppliers1"
  add_foreign_key "calculator_options", "calculator_question", column: "question_id", name: "question_options"
  add_foreign_key "calculator_question", "calculator_category", column: "category_id", name: "calculaor_cateogry"
  add_foreign_key "calculator_result", "calculator_options", column: "option_id", name: "calculator_option"
  add_foreign_key "calculator_result", "calculator_question", column: "question_id", name: "calculator_question"
  add_foreign_key "calculator_result", "calculator_users", column: "users_id", name: "calculator_user"
  add_foreign_key "chat_call_schedule", "chat_room", name: "chat_room_call"
  add_foreign_key "chat_call_schedule_slots", "chat_call_schedule", name: "chat_room_schedule_slots"
  add_foreign_key "chat_messages", "chat_room", name: "fk_chat_room_has_message"
  add_foreign_key "chat_messages", "chat_room_has_users", column: "chat_message_has_user_id", name: "fk_chat_room_has_user"
  add_foreign_key "chat_messages", "chat_template", name: "fk_chat_messages_chat_template1"
  add_foreign_key "chat_room_has_users", "chat_room", name: "fk_chat_room_has_users_chat_room1"
  add_foreign_key "chat_room_has_users", "users", column: "users_id", name: "fk_chat_room_has_users_users1"
  add_foreign_key "chat_seen_by", "chat_messages", column: "chat_messages_id", name: "chat_messag_has_users"
  add_foreign_key "chat_seen_by", "users", column: "users_id", name: "chat_seen_has_users"
  add_foreign_key "cities", "countries", column: "countries_id", name: "fk_cities_countries1"
  add_foreign_key "client_milestones", "client_profiles", column: "client_profiles_id", name: "fk_client_milestones_client_profiles1"
  add_foreign_key "client_payment", "client_milestones", column: "client_milestones_id", name: "fk_client_payment_client_milestones1"
  add_foreign_key "client_profiles", "users", column: "manager_id", name: "fk_client_profiles_manager1"
  add_foreign_key "client_profiles", "users", column: "users_id", name: "fk_client_profiles_users1"
  add_foreign_key "client_profiles_has_cities", "cities", column: "cities_id", name: "fk_client_profiles_has_cities_cities1"
  add_foreign_key "client_profiles_has_cities", "client_profiles", column: "client_profiles_id", name: "fk_client_profiles_has_cities_client_profiles1"
  add_foreign_key "client_project_documents", "client_projects", column: "client_projects_id", name: "fk_client_project_documents_client_projects1"
  add_foreign_key "client_project_flows", "client_projects", column: "client_projects_id", name: "fk_client_project_flows_client_projects1"
  add_foreign_key "client_project_progress", "client_projects", column: "client_projects_id", name: "fk_client_project_progress_client_projects1"
  add_foreign_key "client_project_status", "client_portfolio", name: "fk_client_project_status_client_portfolio1"
  add_foreign_key "client_projects", "client_profiles", column: "client_profiles_id", name: "fk_client_projects_client_profiles1"
  add_foreign_key "client_projects", "current_status", name: "fk_client_projects_current_status1"
  add_foreign_key "client_projects_has_industries", "client_projects", column: "client_projects_id", name: "fk_client_projects_has_industries_client_projects1"
  add_foreign_key "client_projects_has_industries", "industries", column: "industries_id", name: "fk_client_projects_has_industries_industries1"
  add_foreign_key "client_projects_has_services", "client_projects", column: "client_projects_id", name: "fk_client_projects_has_services_client_projects1"
  add_foreign_key "client_projects_has_services", "services", column: "services_id", name: "fk_client_projects_has_services_services1"
  add_foreign_key "client_projects_has_skills", "client_projects", column: "client_projects_id", name: "fk_client_projects_has_skills_client_projects1"
  add_foreign_key "client_projects_has_skills", "skills", column: "skills_id", name: "fk_client_projects_has_skills_skills1"
  add_foreign_key "client_projects_has_tags", "client_projects", column: "client_projects_id", name: "fk_tag_project", on_update: :cascade, on_delete: :cascade
  add_foreign_key "client_projects_has_tags", "tags", name: "fk_tag_tags", on_update: :cascade, on_delete: :cascade
  add_foreign_key "client_projects_questions", "client_projects", column: "client_projects_id", name: "fk_client_projects_questions_client_projects1"
  add_foreign_key "client_services", "client_profiles", column: "client_profiles_id", name: "fk_client_services_client_profiles1"
  add_foreign_key "client_team", "client_portfolio", name: "fk_client_team_client_portfolio1"
  add_foreign_key "code_review_categories", "code_categories"
  add_foreign_key "code_review_categories", "code_reviews"
  add_foreign_key "countries", "regions", column: "regions_id", name: "fk_countries_regions1"
  add_foreign_key "decline_response", "decline_partner_questions", column: "decline_partner_questions_id", name: "partner_question"
  add_foreign_key "decline_response", "suppliers_projects", column: "suppliers_projects_id", name: "supplierProject_id"
  add_foreign_key "in_comment_has_reports", "in_post_has_comments", column: "in_post_has_comments_id", name: "fk_in_comment_has_reports_in_users_has_comments1"
  add_foreign_key "in_comment_has_reports", "users", column: "users_id", name: "fk_in_comment_has_reports_users1"
  add_foreign_key "in_comment_has_shares", "in_post_has_comments", column: "in_post_has_comments_id", name: "fk_in_comment_has_shares_in_users_has_comments1"
  add_foreign_key "in_comment_has_shares", "users", column: "users_id", name: "fk_in_comment_has_shares_users1"
  add_foreign_key "in_comment_has_upvotes", "in_post_has_comments", column: "in_post_has_comments_id", name: "fk_in_comment_has_upvotes_in_users_has_comments1"
  add_foreign_key "in_comment_has_upvotes", "users", column: "users_id", name: "fk_in_comment_has_upvotes_users1"
  add_foreign_key "in_comment_has_users", "in_post_has_comments", column: "in_post_has_comments_id", name: "fk_in_comment_has_users_in_post_has_comments1"
  add_foreign_key "in_comment_has_users", "users", column: "users_id", name: "fk_in_comment_has_users_users1"
  add_foreign_key "in_comments_closure", "in_post_has_comments", column: "child", name: "fk_in_comments_closure_child_comment", on_delete: :cascade
  add_foreign_key "in_comments_closure", "in_post_has_comments", column: "parent", name: "fk_in_comments_closure_parent_comment", on_delete: :cascade
  add_foreign_key "in_enterprise_has_index", "in_innovation_index", name: "fk_enterprise_has_index", on_update: :cascade, on_delete: :cascade
  add_foreign_key "in_enterprise_has_index", "in_users_has_enterprise", column: "in_user_enterprise_id", name: "fk_enterprise_index", on_update: :cascade, on_delete: :cascade
  add_foreign_key "in_enterprise_has_users", "in_role", name: "fk_role2"
  add_foreign_key "in_enterprise_has_users", "in_users_has_enterprise", column: "in_user_enterprise_id", name: "fk_user_has_enterprise"
  add_foreign_key "in_enterprise_has_users", "users", column: "users_id", name: "fk_forum_users2"
  add_foreign_key "in_innovation_log", "users", column: "from_user", name: "in_innovation_log_ibfk_1"
  add_foreign_key "in_innovation_log", "users", column: "users_id", name: "fk_log_has_user"
  add_foreign_key "in_post_has_comments", "in_users_has_posts", column: "users_has_posts_id", name: "fk_users_has_post_has_comments_users_has_posts1"
  add_foreign_key "in_post_has_comments", "users", column: "users_id", name: "fk_users_has_post_has_comments_users1"
  add_foreign_key "in_post_has_index", "in_innovation_index", name: "fk_in_post_has_index_in_innovation_index1"
  add_foreign_key "in_post_has_index", "in_users_has_posts", column: "in_users_has_posts_id", name: "fk_in_post_has_index_in_users_has_posts1"
  add_foreign_key "in_post_has_media", "in_users_has_posts", column: "in_users_has_posts_id", name: "fk_in_post_has_media_in_users_has_posts1"
  add_foreign_key "in_post_has_reports", "in_users_has_enterprise", column: "in_user_enterprise_id", name: "fk_user_has_enterprise_reports"
  add_foreign_key "in_post_has_reports", "in_users_has_posts", column: "in_users_has_posts_id", name: "fk_in_post_has_flag_in_users_has_posts1"
  add_foreign_key "in_post_has_reports", "users", column: "users_id", name: "fk_in_post_has_flag_users1"
  add_foreign_key "in_post_has_shares", "in_users_has_posts", column: "users_has_posts_id", name: "fk_post_has_shares_users_has_posts1"
  add_foreign_key "in_post_has_shares", "users", column: "users_id", name: "fk_post_has_shares_users1"
  add_foreign_key "in_post_has_upvote", "in_users_has_posts", column: "users_has_posts_id", name: "fk_upvotes_has_in_user_has_post_id"
  add_foreign_key "in_post_has_upvote", "users", column: "users_id", name: "fk_post_upvotes_has_users_id"
  add_foreign_key "in_post_has_users", "in_users_has_posts", column: "in_users_has_posts_id", name: "fk_in_post_has_users_in_users_has_posts1"
  add_foreign_key "in_post_has_users", "users", column: "users_id", name: "fk_in_post_has_users_users1"
  add_foreign_key "in_top_index_user", "in_innovation_index", name: "fk_influencer_has_index"
  add_foreign_key "in_top_index_user", "in_users_has_enterprise", column: "in_enterprise_id", name: "fk_influencer_has_enterprise"
  add_foreign_key "in_top_index_user", "users", column: "users_id", name: "fk_influencer_has_users"
  add_foreign_key "in_users_has_enterprise", "users", column: "users_id", name: "fk_in_users_has_profile_users1"
  add_foreign_key "in_users_has_index", "in_innovation_index", name: "fk_in_users_has_index_in_innovation_index1"
  add_foreign_key "in_users_has_index", "users", column: "users_id", name: "fk_in_users_has_index_users1"
  add_foreign_key "in_users_has_posts", "in_users_has_enterprise", column: "in_user_enterprise_id", name: "fk_post_enterprise"
  add_foreign_key "in_users_has_posts", "users", column: "users_id", name: "fk_posts_users1"
  add_foreign_key "linkedin_connections", "cities", column: "cities_id", name: "fk_linkedin_connections_cities1"
  add_foreign_key "linkedin_connections", "users", column: "users_id", name: "fk_linkedin_connections_users1"
  add_foreign_key "log", "users", column: "login_id", name: "fk_log_users1"
  add_foreign_key "milestones_has_order_status", "pitch_has_milestones", column: "supplier_milestones_id", name: "fk_milestones_has_order_status_pitch_has_milestones1"
  add_foreign_key "notifications", "users", column: "users_id", name: "fk_notifications_users1"
  add_foreign_key "paysimple_payment", "users", column: "users_id", name: "paysimpleuseridfk"
  add_foreign_key "pitch_has_milestones", "milestone_status", column: "status", name: "status", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pitch_has_milestones", "proposal_pitches", column: "proposal_pitches_id", name: "fk_supplier_has_milestones_proposal_pitches"
  add_foreign_key "pitch_has_milestones", "users", column: "users_id", name: "fk_pitch_has_milestones_users"
  add_foreign_key "price_tier", "price_zone", name: "fk_price_tier_price_zone1"
  add_foreign_key "project_references", "client_projects", column: "client_projects_id", name: "fk_project_references_client_projects1"
  add_foreign_key "proposal_documents", "suppliers_projects", column: "proposals_id", name: "fk_proposal_documents_proposals1"
  add_foreign_key "proposal_pitches", "suppliers_projects", column: "suppliers_projects_id", name: "fk_proposal_pitches_suppliers_projects1"
  add_foreign_key "proposal_pitches", "users", column: "users_id", name: "fk_proposal_pitches_users1"
  add_foreign_key "ref_projects_terms", "client_projects", column: "client_projects_id", name: "fk_project_id"
  add_foreign_key "ref_redeem_benefit", "ref_transaction", name: "fk_ref_transaction_redeem"
  add_foreign_key "ref_transaction", "ref_wallet", name: "fk_wallet"
  add_foreign_key "ref_wallet", "users", column: "users_id", name: "fk_users_id"
  add_foreign_key "referral", "role", column: "users_role", name: "fk_member_role"
  add_foreign_key "referral", "users", column: "referance_id", name: "fk_refranced_user"
  add_foreign_key "referral", "users", column: "referral_id", name: "fk_referral_member"
  add_foreign_key "repo_category_stats", "code_categories"
  add_foreign_key "repo_category_stats", "supplier_project_repos"
  add_foreign_key "review_questions", "review_category", name: "fk_review_questions_review_category1"
  add_foreign_key "search_criteria", "users", name: "user", on_update: :cascade, on_delete: :cascade
  add_foreign_key "supplier_has_milestones", "suppliers", column: "suppliers_id", name: "fk_supplier_has_milestones_suppliers1"
  add_foreign_key "suppliers", "users", column: "users_id", name: "fk_suppliers_users1"
  add_foreign_key "suppliers_faq_answers", "faq", name: "fk_suppliers_has_faq_faq1"
  add_foreign_key "suppliers_faq_answers", "suppliers", column: "suppliers_id", name: "fk_suppliers_has_faq_suppliers1"
  add_foreign_key "suppliers_has_category_rating", "review_category", name: "fk_suppliers_has_references_has_review_category_review_catego1"
  add_foreign_key "suppliers_has_category_rating", "suppliers_has_references", column: "suppliers_has_references_id", name: "fk_suppliers_has_references_has_review_category_suppliers_has1"
  add_foreign_key "suppliers_has_cities", "cities", column: "cities_id", name: "fk_suppliers_has_cities_cities1"
  add_foreign_key "suppliers_has_cities", "suppliers", column: "suppliers_id", name: "fk_suppliers_has_cities_suppliers1"
  add_foreign_key "suppliers_has_industries", "industries", column: "industries_id", name: "fk_suppliers_has_industries_industries1"
  add_foreign_key "suppliers_has_industries", "suppliers", column: "suppliers_id", name: "fk_suppliers_has_industries_suppliers1"
  add_foreign_key "suppliers_has_portfolio", "suppliers", column: "suppliers_id", name: "fk_suppliers_portfolio_suppliers1"
  add_foreign_key "suppliers_has_portfolio_has_services", "services", column: "services_id", name: "fk_suppliers_has_portfolio_has_services_services1"
  add_foreign_key "suppliers_has_portfolio_has_services", "suppliers_has_portfolio", name: "fk_suppliers_has_portfolio_has_services_suppliers_has_portfol1"
  add_foreign_key "suppliers_has_portfolio_has_skills", "skills", column: "skills_id", name: "fk_suppliers_has_portfolio_has_skills_skills1"
  add_foreign_key "suppliers_has_portfolio_has_skills", "suppliers_has_portfolio", name: "fk_suppliers_has_portfolio_has_skills_suppliers_has_portfolio1"
  add_foreign_key "suppliers_has_references", "client_profiles", column: "client_profiles_id", name: "fk_suppliers_has_references_client_profiles1"
  add_foreign_key "suppliers_has_references", "suppliers", column: "suppliers_id", name: "fk_suppliers_references_suppliers1"
  add_foreign_key "suppliers_has_references", "suppliers_has_portfolio", name: "suppliers_has_references_ibfk_1"
  add_foreign_key "suppliers_has_services", "services", column: "services_id", name: "fk_suppliers_has_services1_services1"
  add_foreign_key "suppliers_has_services", "suppliers", column: "suppliers_id", name: "fk_suppliers_has_services1_suppliers1"
  add_foreign_key "suppliers_has_skills", "skills", column: "skills_id", name: "fk_suppliers_has_skills1_skills1"
  add_foreign_key "suppliers_has_skills", "suppliers", column: "suppliers_id", name: "fk_suppliers_has_skills1_suppliers1"
  add_foreign_key "suppliers_portfolio_has_team", "suppliers_has_portfolio", name: "fk_suppliers_portfolio_has_team_suppliers_has_portfolio1"
  add_foreign_key "suppliers_portfolio_images", "suppliers_has_portfolio", name: "fk_suppliers_portfolio_images_suppliers_has_portfolio1"
  add_foreign_key "suppliers_projects", "chat_room", name: "fk_chat_room_proposal"
  add_foreign_key "suppliers_projects", "client_projects", column: "client_projects_id", name: "fk_proposals_client_projects1"
  add_foreign_key "suppliers_projects", "suppliers", column: "suppliers_id", name: "fk_proposals_supplier"
  add_foreign_key "suppliers_projects", "users", column: "manager_id", name: "fk_supplier_project_manager"
  add_foreign_key "suppliers_references_questions", "review_questions", column: "review_questions_id", name: "fk_suppliers_has_references_has_review_questions_review_quest1"
  add_foreign_key "suppliers_references_questions", "suppliers_has_references", column: "suppliers_has_references_id", name: "fk_suppliers_has_references_has_review_questions_suppliers_ha1"
  add_foreign_key "suppliers_transactions", "users", column: "users_id", name: "transaction_usres", on_update: :cascade, on_delete: :cascade
  add_foreign_key "synapse_payment", "users", column: "users_id", name: "synapseUsers", on_update: :cascade, on_delete: :cascade
  add_foreign_key "team", "users", column: "users_id", name: "fk_team_users1"
  add_foreign_key "transaction_milestones", "pitch_has_milestones", column: "milestone_id", name: "transaction_milestone", on_update: :cascade, on_delete: :cascade
  add_foreign_key "transaction_milestones", "suppliers_transactions", column: "transaction_id", name: "sup_transaction", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "role", name: "fk_users_role1"
  add_foreign_key "users_has_cities", "cities", column: "cities_id", name: "fk_users_has_cities_cities1"
  add_foreign_key "users_has_cities", "users", column: "users_id", name: "fk_users_has_cities_users1"
  add_foreign_key "users_has_team", "team", name: "fk_users_has_team_team1"
  add_foreign_key "users_has_team", "users", column: "users_id", name: "fk_users_has_team_users1"
  add_foreign_key "users_offices", "cities", name: "fk_office_city"
  add_foreign_key "users_offices", "office_type", column: "dep_id", name: "fk_office_type"
  add_foreign_key "users_offices", "users", name: "fk_user_office"
  add_foreign_key "users_team_members", "users", name: "fk_users_team"
end
