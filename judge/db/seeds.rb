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

lang = Language.new
lang.name="C++"
lang.ltype="1"
lang.compilation="/usr/bin/g++ -Wall -O2 -static -pipe -o SOURCE SOURCE.cpp"
lang.execution="SRUN -uCP -F10 -tTL -Ujailu -Gjailg -iINFILE -oSOURCE.OUT -eSOURCE.ERR -n0 -C. -f20000 -d512000 -mML ./SOURCE"
lang.save

lang = Language.new
lang.name="ANSI C"
lang.ltype="1"
lang.compilation="/usr/bin/gcc -Wall -O2 -static -pipe -o SOURCE SOURCE.c"
lang.execution="SRUN -uCP -F10 -tTL -Ujailu -Gjailg -iINFILE -oSOURCE.OUT -eSOURCE.ERR -n0 -C. -f20000 -d512000 -mML ./SOURCE"
lang.save

lang = Language.new
lang.name="Java"
lang.ltype="1"
lang.compilation="/usr/bin/javac -d . SOURCE.java 2>SOURCE.ERR"
lang.execution="SRUN -tTL -TRTL -iINFILE -F256 -u256 -oSOURCE.OUT -eSOURCE.ERR -Ujailu -Gjailg -n0 -C. -f20000 -d1000000 -m1000000 -- /usr/bin/java -Xmx120M -Xms120M SOURCE"
lang.save

lang = Language.new
lang.name="Python"
lang.ltype="2"
lang.compilation=""
lang.execution="SRUN -uCP -F10 -tTL -Ujailu -Gjailg -iINFILE -oSOURCE.OUT -eSOURCE.ERR -n0 -C. -f20000 -d512000 -mML -- /usr/bin/python SOURCE.py"
lang.save
