require "test_helper"

class Public::SpotsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_spots_index_url
    assert_response :success
  end
end
