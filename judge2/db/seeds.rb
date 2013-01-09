# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

roles = Role.create([{:name => "Root"},{:name => "Problem setter"},{:name => "General User"}])
root = User.new
root.email="root@utp.edu.co"
root.password="root@utp.edu.co"
root.save
root.roles << roles
