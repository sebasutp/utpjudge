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

ActiveRecord::Schema.define(:version => 20130110235421) do

  create_table "exercise_problems", :force => true do |t|
    t.integer  "problem_number"
    t.integer  "time_limit"
    t.integer  "score"
    t.integer  "exercise_id"
    t.integer  "problem_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "mem_lim"
    t.integer  "stype"
    t.integer  "prog_limit"
  end

  add_index "exercise_problems", ["exercise_id"], :name => "index_excercise_problems_on_excercise_id"
  add_index "exercise_problems", ["problem_id"], :name => "index_excercise_problems_on_problem_id"

  create_table "exercises", :force => true do |t|
    t.string   "name"
    t.datetime "from_date"
    t.datetime "to_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "problem_excercises", :force => true do |t|
    t.integer  "excercise_id"
    t.integer  "problem_id"
    t.integer  "timelimit"
    t.integer  "score"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "pdescription_file_name"
    t.string   "pdescription_content_type"
    t.integer  "pdescription_file_size"
    t.datetime "pdescription_updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "submissions", :force => true do |t|
    t.datetime "init_date"
    t.datetime "end_date"
    t.string   "veredict"
    t.integer  "time"
    t.integer  "exercise_problem_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "srcfile_file_name"
    t.string   "srcfile_content_type"
    t.integer  "srcfile_file_size"
    t.datetime "srcfile_updated_at"
    t.string   "outfile_file_name"
    t.string   "outfile_content_type"
    t.integer  "outfile_file_size"
    t.datetime "outfile_updated_at"
    t.integer  "tcaseId"
  end

  add_index "submissions", ["exercise_problem_id"], :name => "index_submissions_on_excercise_problem_id"

  create_table "testcases", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "jtype"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "outfile_file_name"
    t.string   "outfile_content_type"
    t.integer  "outfile_file_size"
    t.datetime "outfile_updated_at"
    t.string   "infile_file_name"
    t.string   "infile_content_type"
    t.integer  "infile_file_size"
    t.datetime "infile_updated_at"
  end

  add_index "testcases", ["problem_id"], :name => "index_testcases_on_problem_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
