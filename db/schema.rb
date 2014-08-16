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

ActiveRecord::Schema.define(version: 20140816041736) do

  create_table "ads", force: true do |t|
    t.string   "title"
    t.integer  "position_id"
    t.integer  "user_id"
    t.string   "description"
    t.string   "url"
    t.string   "cover"
    t.boolean  "available",   default: true
    t.integer  "start_on"
    t.integer  "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "catalogs", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "parent_id",  default: 0
    t.string   "slug"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "childs",     default: 0
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent"
    t.integer  "sort"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display",     default: true
    t.boolean  "recommend",   default: false
    t.string   "title"
    t.string   "keywords"
    t.string   "description"
  end

  create_table "colors", force: true do |t|
    t.integer  "photo_id"
    t.string   "hex",        limit: 6
    t.integer  "r",          limit: 3
    t.integer  "g",          limit: 3
    t.integer  "b",          limit: 3
    t.float    "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fans_of_items", force: true do |t|
    t.integer "user_id"
    t.integer "item_id"
  end

  add_index "fans_of_items", ["user_id", "item_id"], name: "user like some item", unique: true, using: :btree

  create_table "followerships", force: true do |t|
    t.integer "follower_id"
    t.integer "following_id"
  end

  add_index "followerships", ["follower_id", "following_id"], name: "follower follow following", unique: true, using: :btree

  create_table "items", force: true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "url"
    t.string   "cover"
    t.decimal  "price",                     precision: 10, scale: 2
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",                                        default: 0
    t.integer  "comments_count",                                     default: 0
    t.integer  "views_count",                                        default: 0
    t.string   "catalog",        limit: 32
    t.decimal  "mprice",                    precision: 10, scale: 2
    t.integer  "status",                                             default: 0
    t.string   "provider",       limit: 16
    t.integer  "iid",            limit: 8
  end

  add_index "items", ["provider", "iid"], name: "provider", unique: true, using: :btree
  add_index "items", ["user_id"], name: "user", using: :btree
  add_index "items", ["user_id"], name: "user_id", using: :btree

  create_table "items_of_categories", force: true do |t|
    t.integer "item_id"
    t.integer "category_id"
  end

  create_table "items_of_styles", force: true do |t|
    t.integer "item_id"
    t.integer "style_id"
  end

  add_index "items_of_styles", ["style_id", "item_id"], name: "index_items_of_styles_on_style_id_and_item_id", unique: true, using: :btree

  create_table "items_of_tags", force: true do |t|
    t.integer  "item_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", force: true do |t|
    t.integer  "section_id"
    t.string   "name"
    t.integer  "sort"
    t.integer  "topics_count"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.integer  "catalog_id"
    t.integer  "user_id"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.string   "description"
    t.integer  "sort"
    t.text     "body"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "name"
    t.string   "file"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject_type", limit: 32
    t.string   "color",        limit: 64
    t.boolean  "new",                     default: false
  end

  create_table "positions", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "width"
    t.integer  "height"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promotions", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "cover"
    t.string   "provider"
    t.decimal  "price",                precision: 10, scale: 2
    t.decimal  "mprice",               precision: 10, scale: 2
    t.integer  "status",     limit: 2,                          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "styles", force: true do |t|
    t.integer  "user_id"
    t.string   "cover"
    t.integer  "likes_count"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body"
    t.string   "title"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.boolean  "recommend"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id", default: 0
    t.boolean  "searchable",  default: false
  end

  create_table "task_links", force: true do |t|
    t.string   "title"
    t.string   "cover"
    t.string   "url"
    t.decimal  "price",      precision: 10, scale: 2
    t.integer  "status",                              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_pages", force: true do |t|
    t.string   "url"
    t.integer  "status",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "title"
    t.integer  "node_id"
    t.integer  "user_id"
    t.text     "body"
    t.integer  "likes_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topics", ["node_id"], name: "index on section", using: :btree
  add_index "topics", ["user_id"], name: "user published topics", using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                  limit: 32,                 null: false
    t.string   "name",                   limit: 64
    t.string   "email",                             default: "",    null: false
    t.string   "avatar",                            default: ""
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                   default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.integer  "likes_count",                       default: 0
    t.integer  "followers_count",                   default: 0
    t.integer  "following_count",                   default: 0
    t.integer  "items_count",                       default: 0
    t.integer  "topics_count",                      default: 0
    t.boolean  "admin",                             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
