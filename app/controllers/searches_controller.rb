class SearchesController < ApplicationController
  protect_from_forgery with: :exception

  def index
    @popular_searches = SearchTerm.popular_searches
  end

  def create
    term = sanitized_search_term

    if valid_search_term?(term)
      handle_valid_search_term(term)
    else
      handle_invalid_search_term
    end
  rescue StandardError => e
    render_error_response("Internal Server Error: #{e.message}")
  end

  private

  def sanitized_search_term
    params[:term].to_s.strip.downcase
  end

  def valid_search_term?(term)
    term.present? && term.length <= SearchTerm::MAX_TERM_LENGTH
  end

  def handle_valid_search_term(term)
    session_id = session.id.to_s
    SearchTerm.create_or_update(term, session_id)
    render_search_response('success', term)
  end

  def handle_invalid_search_term
    max_length = SearchTerm::MAX_TERM_LENGTH
    error_message = "Validation failed: Term is too long (maximum is #{max_length} characters)"
    render_error_response(error_message, :unprocessable_entity)
  end

  def render_search_response(status, term)
    render json: {
      status: status,
      term: term,
      time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      popular_searches: SearchTerm.popular_searches
    }
  end

  def render_error_response(message, status = :internal_server_error)
    render json: { status: 'error', message: message }, status: status
  end
end
