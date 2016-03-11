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

ActiveRecord::Schema.define(version: 20160310064154) do

  create_table "branches", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "current_version", limit: 4,   default: 0
    t.integer  "status",          limit: 4,   default: 1
    t.integer  "repository_id",   limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "branches", ["repository_id"], name: "index_branches_on_repository_id", using: :btree

  create_table "category_stats", force: :cascade do |t|
    t.integer  "issue_count",       limit: 4
    t.integer  "file_count",        limit: 4
    t.integer  "analysis_version",  limit: 4
    t.integer  "branch_id",         limit: 4
    t.integer  "issue_category_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "category_stats", ["branch_id"], name: "index_category_stats_on_branch_id", using: :btree
  add_index "category_stats", ["issue_category_id"], name: "index_category_stats_on_issue_category_id", using: :btree

  create_table "code_issues", id: false, force: :cascade do |t|
    t.integer  "id",                limit: 4,                 null: false
    t.text     "file_path",         limit: 65535
    t.text     "issue_text",        limit: 65535
    t.integer  "begin_line",        limit: 4
    t.integer  "end_line",          limit: 4
    t.integer  "issue_column",      limit: 4
    t.text     "source_code",       limit: 65535
    t.integer  "weight",            limit: 4
    t.string   "engine",            limit: 255
    t.string   "engine_ruleset",    limit: 255
    t.integer  "version",           limit: 4
    t.integer  "status",            limit: 4,     default: 0
    t.integer  "branch_id",         limit: 4,     default: 0, null: false
    t.integer  "issue_category_id", limit: 4
    t.integer  "file_list_id",      limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "code_issues", ["branch_id"], name: "index_code_issues_on_branch_id", using: :btree
  add_index "code_issues", ["file_list_id"], name: "index_code_issues_on_file_list_id", using: :btree
  add_index "code_issues", ["issue_category_id"], name: "index_code_issues_on_issue_category_id", using: :btree

  create_table "commits", force: :cascade do |t|
    t.string   "sha",            limit: 255
    t.date     "date"
    t.datetime "full_date"
    t.integer  "additions",      limit: 4
    t.integer  "deletions",      limit: 4
    t.integer  "files_changed",  limit: 4
    t.integer  "contributor_id", limit: 4
    t.integer  "branch_id",      limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "commits", ["branch_id"], name: "index_commits_on_branch_id", using: :btree
  add_index "commits", ["contributor_id"], name: "index_commits_on_contributor_id", using: :btree

  create_table "contributors", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "email",         limit: 255
    t.integer  "additions",     limit: 4
    t.integer  "deletions",     limit: 4
    t.integer  "total_commits", limit: 4
    t.integer  "branch_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "contributors", ["branch_id"], name: "index_contributors_on_branch_id", using: :btree

  create_table "file_lists", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.integer  "is_file",               limit: 4
    t.string   "extension",             limit: 255
    t.integer  "file_size",             limit: 4
    t.string   "phash",                 limit: 255
    t.string   "fhash",                 limit: 255
    t.string   "relative_path",         limit: 255
    t.string   "parent_path",           limit: 255
    t.text     "full_path",             limit: 65535
    t.integer  "is_excluded",           limit: 4,     default: 0
    t.integer  "status",                limit: 4,     default: 1
    t.integer  "branch_id",             limit: 4
    t.integer  "supported_language_id", limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "file_lists", ["branch_id"], name: "index_file_lists_on_branch_id", using: :btree
  add_index "file_lists", ["supported_language_id"], name: "index_file_lists_on_supported_language_id", using: :btree

  create_table "issue_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "status",      limit: 4,     default: 1
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "language_stats", force: :cascade do |t|
    t.integer  "issues_count",          limit: 4
    t.integer  "files_count",           limit: 4
    t.integer  "supported_language_id", limit: 4
    t.integer  "branch_id",             limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "language_stats", ["branch_id"], name: "index_language_stats_on_branch_id", using: :btree
  add_index "language_stats", ["supported_language_id"], name: "index_language_stats_on_supported_language_id", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "username",       limit: 255
    t.string   "owner",          limit: 255
    t.string   "name",           limit: 255
    t.string   "ssh_url",        limit: 255
    t.text     "directory",      limit: 65535
    t.string   "default_branch", limit: 255
    t.string   "current_branch", limit: 255
    t.integer  "is_private",     limit: 4
    t.integer  "is_setup",       limit: 4,     default: 0
    t.integer  "project_id",     limit: 4,                 null: false
    t.integer  "status",         limit: 4,     default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "repositories", ["project_id"], name: "index_repositories_on_project_id", using: :btree

  create_table "request_logs", force: :cascade do |t|
    t.string   "request_type",  limit: 255
    t.integer  "is_waiting",    limit: 4,     default: 0
    t.integer  "is_active",     limit: 4,     default: 0
    t.integer  "is_complete",   limit: 4,     default: 0
    t.integer  "is_error",      limit: 4,     default: 0
    t.text     "error_message", limit: 65535
    t.text     "error_trace",   limit: 65535
    t.integer  "branch_id",     limit: 4
    t.integer  "repository_id", limit: 4
    t.integer  "status",        limit: 4,     default: 1
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "request_logs", ["branch_id"], name: "index_request_logs_on_branch_id", using: :btree
  add_index "request_logs", ["repository_id"], name: "index_request_logs_on_repository_id", using: :btree

  create_table "supported_languages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "branches", "repositories"
  add_foreign_key "category_stats", "branches"
  add_foreign_key "category_stats", "issue_categories"
  add_foreign_key "commits", "branches"
  add_foreign_key "commits", "contributors"
  add_foreign_key "contributors", "branches"
  add_foreign_key "file_lists", "branches"
  add_foreign_key "file_lists", "supported_languages"
  add_foreign_key "language_stats", "branches"
  add_foreign_key "language_stats", "supported_languages"
  add_foreign_key "request_logs", "branches"
  add_foreign_key "request_logs", "repositories"
end
