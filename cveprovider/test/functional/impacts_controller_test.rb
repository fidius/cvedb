require 'test_helper'

class ImpactsControllerTest < ActionController::TestCase
  setup do
    @impact = impacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:impacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create impact" do
    assert_difference('Impact.count') do
      post :create, :impact => @impact.attributes
    end

    assert_redirected_to impact_path(assigns(:impact))
  end

  test "should show impact" do
    get :show, :id => @impact.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @impact.to_param
    assert_response :success
  end

  test "should update impact" do
    put :update, :id => @impact.to_param, :impact => @impact.attributes
    assert_redirected_to impact_path(assigns(:impact))
  end

  test "should destroy impact" do
    assert_difference('Impact.count', -1) do
      delete :destroy, :id => @impact.to_param
    end

    assert_redirected_to impacts_path
  end
end
