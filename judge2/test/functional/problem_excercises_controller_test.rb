require 'test_helper'

class ProblemExcercisesControllerTest < ActionController::TestCase
  setup do
    @problem_excercise = problem_excercises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:problem_excercises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create problem_excercise" do
    assert_difference('ProblemExcercise.count') do
      post :create, :problem_excercise => { :excercise_id => @problem_excercise.excercise_id, :problem_id => @problem_excercise.problem_id, :score => @problem_excercise.score, :timelimit => @problem_excercise.timelimit }
    end

    assert_redirected_to problem_excercise_path(assigns(:problem_excercise))
  end

  test "should show problem_excercise" do
    get :show, :id => @problem_excercise
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @problem_excercise
    assert_response :success
  end

  test "should update problem_excercise" do
    put :update, :id => @problem_excercise, :problem_excercise => { :excercise_id => @problem_excercise.excercise_id, :problem_id => @problem_excercise.problem_id, :score => @problem_excercise.score, :timelimit => @problem_excercise.timelimit }
    assert_redirected_to problem_excercise_path(assigns(:problem_excercise))
  end

  test "should destroy problem_excercise" do
    assert_difference('ProblemExcercise.count', -1) do
      delete :destroy, :id => @problem_excercise
    end

    assert_redirected_to problem_excercises_path
  end
end
