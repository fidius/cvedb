require 'test_helper'

class ReferencesControllerTest < ActionController::TestCase
  setup do
    @reference = references(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:references)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reference" do
    assert_difference('Reference.count') do
      post :create, :reference => @reference.attributes
    end

    assert_redirected_to reference_path(assigns(:reference))
  end

  test "should show reference" do
    get :show, :id => @reference.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reference.to_param
    assert_response :success
  end

  test "should update reference" do
    put :update, :id => @reference.to_param, :reference => @reference.attributes
    assert_redirected_to reference_path(assigns(:reference))
  end

  test "should destroy reference" do
    assert_difference('Reference.count', -1) do
      delete :destroy, :id => @reference.to_param
    end

    assert_redirected_to references_path
  end
end
