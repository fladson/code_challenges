ActiveRecord::Schema.define(version: 20170813193940) do
  enable_extension "plpgsql"

  create_table "playlists", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.text "mp3_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.string "interpret"
    t.string "album"
    t.string "track"
    t.string "year"
    t.string "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "user_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "playlists", "users"
end
