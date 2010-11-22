require 'test_helper'

class AvailabilityImpactsControllerTest < ActionController::TestCase
  setup do
    @availability_impact = availability_impacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:availability_impacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create availability_impact" do
    assert_difference('AvailabilityImpact.count') do
      post :create, :availability_impact => @availability_impact.attributes
    end

    assert_redirected_to availability_impact_path(assigns(:availability_impact))
  end

  test "should show availability_impact" do
    get :show, :id => @availability_impact.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @availability_impact.to_param
    assert_response :success
  end

  test "should update availability_impact" do
    put :update, :id => @availability_impact.to_param, :availability_impact => @availability_impact.attributes
    assert_redirected_to availability_impact_path(assigns(:availability_impact))
  end

  test "should destroy availability_impact" do
    assert_difference('AvailabilityImpact.count', -1) do
      delete :destroy, :id => @availability_impact.to_param
    end

    assert_redirected_to availability_impacts_path
  end
end
