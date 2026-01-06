require "test_helper"

class Public::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_home_index_url
    assert_response :success
  end
end
