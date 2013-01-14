require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:exercises)
  end
end
