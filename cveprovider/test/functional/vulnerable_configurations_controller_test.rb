require 'test_helper'

class VulnerableConfigurationsControllerTest < ActionController::TestCase
  setup do
    @vulnerable_configuration = vulnerable_configurations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vulnerable_configurations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vulnerable_configuration" do
    assert_difference('VulnerableConfiguration.count') do
      post :create, :vulnerable_configuration => @vulnerable_configuration.attributes
    end

    assert_redirected_to vulnerable_configuration_path(assigns(:vulnerable_configuration))
  end

  test "should show vulnerable_configuration" do
    get :show, :id => @vulnerable_configuration.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vulnerable_configuration.to_param
    assert_response :success
  end

  test "should update vulnerable_configuration" do
    put :update, :id => @vulnerable_configuration.to_param, :vulnerable_configuration => @vulnerable_configuration.attributes
    assert_redirected_to vulnerable_configuration_path(assigns(:vulnerable_configuration))
  end

  test "should destroy vulnerable_configuration" do
    assert_difference('VulnerableConfiguration.count', -1) do
      delete :destroy, :id => @vulnerable_configuration.to_param
    end

    assert_redirected_to vulnerable_configurations_path
  end
end
