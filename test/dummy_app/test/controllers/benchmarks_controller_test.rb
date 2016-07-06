require 'test_helper'

class BenchmarksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get benchmarks_index_url
    assert_response :success
  end

end
