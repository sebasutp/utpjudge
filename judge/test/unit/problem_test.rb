require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
  test "right path" do
    p = Problem.new(:name=>"Trilo",:description=>"Sumar dos numeros")
    assert p.save
    a = Problem.where(:name=>"Trilo")
    assert a.count==1
  end

  test "no data" do
    p = Problem.new
    assert !p.save
    for f in [:name]
      assert p.errors[f].any?
    end
  end
end
