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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130411175838) do

  create_table "episode_trackers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "episode_id"
    t.boolean  "watched"
    t.boolean  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "episode_trackers", ["user_id", "episode_id"], :name => "index_episode_trackers_on_user_id_and_episode_id"

  create_table "episodes", :force => true do |t|
    t.integer  "tv_show_id"
    t.string   "tvdb_id"
    t.string   "imdb_id"
    t.string   "name"
    t.string   "season_num"
    t.string   "episode_num"
    t.string   "first_aired"
    t.text     "overview"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "episodes", ["tv_show_id"], :name => "index_episodes_on_tv_show_id"

  create_table "movie_trackers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "movie_id"
    t.boolean  "watched"
    t.boolean  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "movie_trackers", ["user_id", "movie_id"], :name => "index_movie_trackers_on_user_id_and_movie_id"

  create_table "movies", :force => true do |t|
    t.integer  "tmdb_id"
    t.string   "imdb_id"
    t.string   "title"
    t.string   "release_date"
    t.text     "overview"
    t.string   "status"
    t.integer  "run_time"
    t.string   "production_company"
    t.string   "language"
    t.string   "genre"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "movies", ["title"], :name => "index_movies_on_title"

  create_table "tv_relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tv_show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tv_relationships", ["tv_show_id"], :name => "index_tv_relationships_on_tv_show_id"
  add_index "tv_relationships", ["user_id", "tv_show_id"], :name => "index_tv_relationships_on_user_id_and_tv_show_id", :unique => true
  add_index "tv_relationships", ["user_id"], :name => "index_tv_relationships_on_user_id"

  create_table "tv_shows", :force => true do |t|
    t.string   "tvdb_id"
    t.string   "name"
    t.string   "year"
    t.string   "network"
    t.string   "genre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "overview"
    t.string   "imdb_id"
    t.string   "runtime"
  end

  add_index "tv_shows", ["tvdb_id"], :name => "index_tv_shows_on_tvdb_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                   :default => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_token_sent"
    t.boolean  "active",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
