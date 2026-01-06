require "test_helper"

class Telefizz::BoardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get telefizz_board_index_url
    assert_response :success
  end
end
