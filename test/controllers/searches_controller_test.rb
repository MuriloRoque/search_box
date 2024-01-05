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

    # Validate the response JSON structure
    response_json = JSON.parse(@response.body)
    assert_equal 'success', response_json['status']
    assert_equal 'example', response_json['term']
    assert_not_nil response_json['time']
    assert_not_nil response_json['popular_searches']
  end

  test 'should not create search term with an existing term exceeding the maximum length' do
    # Create an initial search term
    post searches_url, params: { term: 'example' }
    assert_response :success

    # Attempt to create another search term with the same term but exceeding the maximum length
    post searches_url, params: { term: 'a' * 256 }  # Assuming a maximum length of 255 characters
    assert_response :unprocessable_entity

    # Validate the error response JSON structure
    expected_error_response = '{"status":"error","message":"Validation failed: Term is too long (maximum is 255 characters)"}'
    assert_equal expected_error_response, @response.body
  end

  test 'should not create search term with term exceeding the maximum length' do
    post searches_url, params: { term: 'a' * 256 }  # Assuming a maximum length of 255 characters
    assert_response :unprocessable_entity

    # Validate the error response JSON structure
    expected_error_response = '{"status":"error","message":"Validation failed: Term is too long (maximum is 255 characters)"}'
    assert_equal expected_error_response, @response.body
  end
end
