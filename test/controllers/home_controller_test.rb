require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  #トップページへのアクセステスト
  test "should get root" do   
    get root_url
    assert_response :success
  end
end
