require 'test_helper'

class UserTest < ActiveSupport::TestCase
  %{test "right path" do
      u = User.newMA(:name=>"Test user name",:email=>"test@test.in",:password=>"sec123",:code=>123)
      assert u.save
      u = User.where(:name => "Test user name")
      assert u.count == 1
  end
  
  test "no data" do
      u = User.new
      assert !u.save
      for p in [:name,:email,:code,:password]
        assert u.errors[p].any?
      end
  end
  
  test "missing data" do
      u = User.newMA(:code=>123)
      assert !u.save
      for p in [:name,:email,:code,:password]
        assert u.errors[p].any?
      end
  end
  
  test "wrong format email" do
      u = User.newMA(:name=>"Test user name",:email=>"test.in",:password=>"sec123",:code=>123)
      assert !u.save
      for p in [:name,:email,:code,:password]
        assert u.errors[p].any?
      end
  end
  %}
end
