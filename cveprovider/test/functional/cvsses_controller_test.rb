require 'test_helper'

class CvssesControllerTest < ActionController::TestCase
  setup do
    @cvss = cvsses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cvsses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cvss" do
    assert_difference('Cvss.count') do
      post :create, :cvss => @cvss.attributes
    end

    assert_redirected_to cvss_path(assigns(:cvss))
  end

  test "should show cvss" do
    get :show, :id => @cvss.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cvss.to_param
    assert_response :success
  end

  test "should update cvss" do
    put :update, :id => @cvss.to_param, :cvss => @cvss.attributes
    assert_redirected_to cvss_path(assigns(:cvss))
  end

  test "should destroy cvss" do
    assert_difference('Cvss.count', -1) do
      delete :destroy, :id => @cvss.to_param
    end

    assert_redirected_to cvsses_path
  end
end
