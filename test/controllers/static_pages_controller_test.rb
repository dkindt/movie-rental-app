require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_response :success
  	assert_select "title", "Ruby on Rails DVD App"
  end

end