class AddColumnLangIdToSubmissions < ActiveRecord::Migration
  def change
      add_column :submissions, :language_id, :int
  end
end
