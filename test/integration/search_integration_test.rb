require 'test_helper'

class SearchIntegrationTest < ActionDispatch::IntegrationTest
  test 'should display popular searches' do
    get searches_url
    assert_response :success

    assert_select 'h2', 'Popular Searches'
  end

  test 'should update popular searches in real-time' do
    post searches_url, params: { term: 'example' }
    assert_response :success

    get searches_url
    assert_response :success

    assert_select 'p', 'example: 1 times'
  end

  test 'should not create search term with a term exceeding the maximum length' do
    post searches_url, params: { term: 'a' * 256 }  # Assuming a maximum length of 255 characters
    assert_response :unprocessable_entity

    assert_equal '{"status":"error","message":"Validation failed: Term is too long (maximum is 255 characters)"}', @response.body
  end

  test 'should not create search term with an existing term exceeding the maximum length' do
    # Create a search term with a term of maximum length
    post searches_url, params: { term: 'a' * 255 }
    assert_response :success

    # Attempt to create another search term with the same term exceeding the maximum length
    post searches_url, params: { term: 'a' * 256 }  # Assuming a maximum length of 255 characters
    assert_response :unprocessable_entity

    assert_equal '{"status":"error","message":"Validation failed: Term is too long (maximum is 255 characters)"}', @response.body
  end
end
