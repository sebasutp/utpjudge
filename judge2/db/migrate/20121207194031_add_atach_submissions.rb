class AddAtachSubmissions < ActiveRecord::Migration
  def up
      add_attachment :submissions, :srcfile
      add_attachment :submissions, :outfile
  end

  def down
      remove_attachment :submissions, :srcfile
      remove_attachment :submissions, :outfile
  end
end
