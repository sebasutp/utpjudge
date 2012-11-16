class CreateProblemExcercises < ActiveRecord::Migration
  def change
    create_table :problem_excercises do |t|
      t.integer :excercise_id
      t.integer :problem_id
      t.integer :timelimit
      t.integer :score

      t.timestamps
    end
  end
end
