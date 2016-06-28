require 'test_helper'

class JbTest < ActionDispatch::IntegrationTest
  test 'The controller works without engines' do
    visit '/posts/1.json'
    assert has_content? 'hello'
  end
end
