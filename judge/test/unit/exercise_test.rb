require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  test "right path" do
      e = Exercise.new(:name=>"Test exercise",:from_date=>DateTime.now,:to_date=>DateTime.now + 1.month)
      assert e.save
      a = Exercise.where(:name => "Test exercise")
      assert a.count == 1
  end

  test "no data" do
      e = Exercise.new
      assert !e.save
      for p in [:name,:from_date,:to_date]
        assert e.errors[p].any?
      end
  end

  test "invalid date-range" do
      e = Exercise.new(:name=>"Test exercise",:from_date=>DateTime.now,:to_date=>DateTime.now - 1.month)
      assert !e.save
  end

end
