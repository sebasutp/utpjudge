class CreateExcercises < ActiveRecord::Migration
  def change
    create_table :excercises do |t|
      t.string :name
      t.string :url
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end
