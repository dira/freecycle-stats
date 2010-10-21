require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index

    assert_response :success
    assert assigns(:per_month_per_kind)
  end
end

