class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.datetime :init_date
      t.datetime :end_date
      t.string :veredict
      t.integer :time
      t.references :excercise_problem

      t.timestamps
    end
    add_index :submissions, :excercise_problem_id
  end
end
