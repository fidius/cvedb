require 'test_helper'

class ConfidentialityImpactsControllerTest < ActionController::TestCase
  setup do
    @confidentiality_impact = confidentiality_impacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:confidentiality_impacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create confidentiality_impact" do
    assert_difference('ConfidentialityImpact.count') do
      post :create, :confidentiality_impact => @confidentiality_impact.attributes
    end

    assert_redirected_to confidentiality_impact_path(assigns(:confidentiality_impact))
  end

  test "should show confidentiality_impact" do
    get :show, :id => @confidentiality_impact.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @confidentiality_impact.to_param
    assert_response :success
  end

  test "should update confidentiality_impact" do
    put :update, :id => @confidentiality_impact.to_param, :confidentiality_impact => @confidentiality_impact.attributes
    assert_redirected_to confidentiality_impact_path(assigns(:confidentiality_impact))
  end

  test "should destroy confidentiality_impact" do
    assert_difference('ConfidentialityImpact.count', -1) do
      delete :destroy, :id => @confidentiality_impact.to_param
    end

    assert_redirected_to confidentiality_impacts_path
  end
end
