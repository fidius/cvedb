require 'test_helper'

class VulnerableSoftwaresControllerTest < ActionController::TestCase
  setup do
    @vulnerable_software = vulnerable_softwares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vulnerable_softwares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vulnerable_software" do
    assert_difference('VulnerableSoftware.count') do
      post :create, :vulnerable_software => @vulnerable_software.attributes
    end

    assert_redirected_to vulnerable_software_path(assigns(:vulnerable_software))
  end

  test "should show vulnerable_software" do
    get :show, :id => @vulnerable_software.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vulnerable_software.to_param
    assert_response :success
  end

  test "should update vulnerable_software" do
    put :update, :id => @vulnerable_software.to_param, :vulnerable_software => @vulnerable_software.attributes
    assert_redirected_to vulnerable_software_path(assigns(:vulnerable_software))
  end

  test "should destroy vulnerable_software" do
    assert_difference('VulnerableSoftware.count', -1) do
      delete :destroy, :id => @vulnerable_software.to_param
    end

    assert_redirected_to vulnerable_softwares_path
  end
end
