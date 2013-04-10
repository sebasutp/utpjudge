class CreateTableExercisesUsers < ActiveRecord::Migration
  def up
    remove_column :users, :exercise_id
    
    create_table :exercises_users, :id => false do |t|
      t.integer :exercise_id
      t.integer :user_id
    end
    
  end

  def down
    drop_table :exercises_users
    
    add_column :users, :exercises_id, :integer
  end

end

