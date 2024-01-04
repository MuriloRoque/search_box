require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get searches_url
    assert_response :success
  end

  test 'should create search term' do
    assert_difference('SearchTerm.count') do
      post searches_url, params: { term: 'example' }
    end

    assert_response :success
    assert_equal 'application/json; charset=utf-8', @response.content_type
  end

  test 'should not create search term with an existing term exceeding the maximum length' do
    # Create an initial search term
    post searches_url, params: { term: 'example' }
    assert_response :success

    # Attempt to create another search term with the same term but exceeding the maximum length
    post searches_url, params: { term: 'a' * 256 }  # Assuming a maximum length of 255 characters
    assert_response :unprocessable_entity

    assert_equal '{"status":"error","message":"Validation failed: Term is too long (maximum is 255 characters)"}', @response.body
  end
end
