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

ActiveRecord::Schema.define(:version => 20121130130931) do

  create_table "excercise_problems", :force => true do |t|
    t.integer  "problem_number"
    t.integer  "time_limit"
    t.integer  "score"
    t.integer  "excercise_id"
    t.integer  "problem_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "excercise_problems", ["excercise_id"], :name => "index_excercise_problems_on_excercise_id"
  add_index "excercise_problems", ["problem_id"], :name => "index_excercise_problems_on_problem_id"

  create_table "excercises", :force => true do |t|
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
    t.string   "url"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "testcases", :force => true do |t|
    t.integer  "problem_id"
    t.string   "infile"
    t.string   "outfile"
    t.integer  "jtype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "testcases", ["problem_id"], :name => "index_testcases_on_problem_id"

end
