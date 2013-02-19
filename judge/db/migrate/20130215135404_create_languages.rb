class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.string :ltype
      t.string :compilation
      t.string :execution

      t.timestamps
    end
  end
end
