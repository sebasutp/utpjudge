class AddAttachmentOutfileToTestcases < ActiveRecord::Migration
  def self.up
    change_table :testcases do |t|
      t.has_attached_file :outfile
    end
  end

  def self.down
    drop_attached_file :testcases, :outfile
  end
end
