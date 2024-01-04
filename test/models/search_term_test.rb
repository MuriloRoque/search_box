require 'test_helper'

class SearchTermTest < ActiveSupport::TestCase
  test 'should not save search term without term' do
    search_term = SearchTerm.new
    assert_not search_term.save, 'Saved the search term without a term'
  end

  test 'should save search term with term' do
    search_term = SearchTerm.new(term: 'example')
    assert search_term.save, 'Failed to save search term with a term'
  end

  test 'should not save search term with a term exceeding the maximum length' do
    long_term = 'a' * (SearchTerm::MAX_TERM_LENGTH + 1)
    search_term = SearchTerm.new(term: long_term)
    assert_not search_term.save, 'Saved the search term with a term exceeding the maximum length'
  end

  test 'should save search term with the maximum allowed term length' do
    max_length_term = 'a' * SearchTerm::MAX_TERM_LENGTH
    search_term = SearchTerm.new(term: max_length_term)
    assert search_term.save, 'Failed to save search term with the maximum allowed term length'
  end

  test 'should save popular searches in descending order of count' do
    # Clear existing records to ensure a clean test environment
    SearchTerm.destroy_all

    # Create test records
    SearchTerm.create(term: 'term1')
    SearchTerm.create(term: 'term2')
    SearchTerm.create(term: 'term1')
    SearchTerm.create(term: 'term3')
    SearchTerm.create(term: 'term2')

    popular_searches = SearchTerm.popular_searches

    # Remove any possible nil values or duplicates from the test data
    expected_result = ['term1', 'term2', 'term3'].uniq.sort

    assert_equal expected_result, popular_searches.keys.sort
    assert_equal [2, 2, 1].sort, popular_searches.values.sort
  end

  test 'should save up to 5 popular searches' do
    (1..10).each { |i| SearchTerm.create(term: "term#{i}") }
    popular_searches = SearchTerm.popular_searches

    assert_equal 5, popular_searches.size
  end
end
