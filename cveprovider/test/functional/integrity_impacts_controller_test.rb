require 'test_helper'

class IntegrityImpactsControllerTest < ActionController::TestCase
  setup do
    @integrity_impact = integrity_impacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:integrity_impacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create integrity_impact" do
    assert_difference('IntegrityImpact.count') do
      post :create, :integrity_impact => @integrity_impact.attributes
    end

    assert_redirected_to integrity_impact_path(assigns(:integrity_impact))
  end

  test "should show integrity_impact" do
    get :show, :id => @integrity_impact.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @integrity_impact.to_param
    assert_response :success
  end

  test "should update integrity_impact" do
    put :update, :id => @integrity_impact.to_param, :integrity_impact => @integrity_impact.attributes
    assert_redirected_to integrity_impact_path(assigns(:integrity_impact))
  end

  test "should destroy integrity_impact" do
    assert_difference('IntegrityImpact.count', -1) do
      delete :destroy, :id => @integrity_impact.to_param
    end

    assert_redirected_to integrity_impacts_path
  end
end
