class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :exercise_problem
      t.references :user
      t.references :testcase
      t.datetime :init_date
      t.datetime :end_date
      t.string :veredict
      t.decimal :time
      t.has_attached_file :srcfile
      t.has_attached_file :outfile

      t.timestamps
    end
    add_index :submissions, :exercise_problem_id
    add_index :submissions, :user_id
    add_index :submissions, :testcase_id
  end
end
