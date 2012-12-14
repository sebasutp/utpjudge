class RenameExercises < ActiveRecord::Migration
  def change
      rename_table :excercises, :exercises
      rename_column :excercise_problems, :excercise_id, :exercise_id
      rename_table :excercise_problems, :exercise_problems
  end
end
