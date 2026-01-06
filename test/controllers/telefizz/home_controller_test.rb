require "test_helper"

class Telefizz::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get telefizz_home_index_url
    assert_response :success
  end
end
