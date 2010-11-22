require 'test_helper'

class NvdEntriesControllerTest < ActionController::TestCase
  setup do
    @nvd_entry = nvd_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nvd_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nvd_entry" do
    assert_difference('NvdEntry.count') do
      post :create, :nvd_entry => @nvd_entry.attributes
    end

    assert_redirected_to nvd_entry_path(assigns(:nvd_entry))
  end

  test "should show nvd_entry" do
    get :show, :id => @nvd_entry.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @nvd_entry.to_param
    assert_response :success
  end

  test "should update nvd_entry" do
    put :update, :id => @nvd_entry.to_param, :nvd_entry => @nvd_entry.attributes
    assert_redirected_to nvd_entry_path(assigns(:nvd_entry))
  end

  test "should destroy nvd_entry" do
    assert_difference('NvdEntry.count', -1) do
      delete :destroy, :id => @nvd_entry.to_param
    end

    assert_redirected_to nvd_entries_path
  end
end
