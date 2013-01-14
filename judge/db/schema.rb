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

ActiveRecord::Schema.define(:version => 20130114174725) do

  create_table "exercise_problems", :force => true do |t|
    t.integer  "problem_number"
    t.integer  "time_limit"
    t.integer  "score"
    t.integer  "exercise_id"
    t.integer  "problem_id"
    t.integer  "mem_lim"
    t.integer  "stype"
    t.integer  "prog_limit"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "exercise_problems", ["exercise_id"], :name => "index_exercise_problems_on_exercise_id"
  add_index "exercise_problems", ["problem_id"], :name => "index_exercise_problems_on_problem_id"

  create_table "exercises", :force => true do |t|
    t.string   "name"
    t.datetime "from_date"
    t.datetime "to_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "notes"
    t.string   "pdescription_file_name"
    t.string   "pdescription_content_type"
    t.integer  "pdescription_file_size"
    t.datetime "pdescription_updated_at"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "testcases", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "jtype"
    t.string   "infile_file_name"
    t.string   "infile_content_type"
    t.integer  "infile_file_size"
    t.datetime "infile_updated_at"
    t.string   "outfile_file_name"
    t.string   "outfile_content_type"
    t.integer  "outfile_file_size"
    t.datetime "outfile_updated_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "testcases", ["problem_id"], :name => "index_testcases_on_problem_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "code"
    t.string   "encrypted_password"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
