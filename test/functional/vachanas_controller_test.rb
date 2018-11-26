require 'test_helper'

class VachanasControllerTest < ActionController::TestCase
  setup do
    @vachana = vachanas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vachanas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vachana" do
    assert_difference('Vachana.count') do
      post :create, vachana: { author: @vachana.author, description: @vachana.description, name: @vachana.name }
    end

    assert_redirected_to vachana_path(assigns(:vachana))
  end

  test "should show vachana" do
    get :show, id: @vachana
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vachana
    assert_response :success
  end

  test "should update vachana" do
    put :update, id: @vachana, vachana: { author: @vachana.author, description: @vachana.description, name: @vachana.name }
    assert_redirected_to vachana_path(assigns(:vachana))
  end

  test "should destroy vachana" do
    assert_difference('Vachana.count', -1) do
      delete :destroy, id: @vachana
    end

    assert_redirected_to vachanas_path
  end
end
