class CreateTableExercisesUsers < ActiveRecord::Migration
  def change
    create_table :exercises_users, :id=>false do |t|
      t.integer "exercise_id"
      t.integer "user_id"
    end
  end
end
