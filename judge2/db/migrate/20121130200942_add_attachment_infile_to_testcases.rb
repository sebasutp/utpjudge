class AddAttachmentInfileToTestcases < ActiveRecord::Migration
  def self.up
    change_table :testcases do |t|
      t.has_attached_file :infile
    end
  end

  def self.down
    drop_attached_file :testcases, :infile
  end
end
