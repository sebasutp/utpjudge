require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  setup do
    @exercise = exercises(:exercise_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exercises)
    #assert_equal assigns(:exercises)[0].name, "Exercise 1"
  end
%{
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exercise" do
    assert_difference('Exercise.count') do
      post :create, :exercise => { :from_date => @exercise.from_date, :name => @exercise.name, :to_date => @exercise.to_date }
    end

    assert_redirected_to exercise_path(assigns(:exercise))
  end

  test "should show exercise" do
    get :show, :id => @exercise
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @exercise
    assert_response :success
  end

  test "should update exercise" do
    put :update, :id => @exercise, :exercise => { :from_date => @exercise.from_date, :name => @exercise.name, :to_date => @exercise.to_date }
    assert_redirected_to exercise_path(assigns(:exercise))
  end

  test "should destroy exercise" do
    assert_difference('Exercise.count', -1) do
      delete :destroy, :id => @excercise
    end

    assert_redirected_to exercises_path
  end
  %}
end
