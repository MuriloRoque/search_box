class SearchesController < ApplicationController
  protect_from_forgery with: :exception
  before_action :set_term, only: [:create]

  def index
    @popular_searches = SearchTerm.popular_searches

    respond_to do |format|
      format.html
      format.json { render json: { popular_searches: @popular_searches } }
    end
  end

  def create
    valid_search_term?(@term) ? handle_valid_search_term : handle_invalid_search_term
  rescue StandardError => e
    render_error_response("Internal Server Error: #{e.message}")
  end

  private

  def set_term
    @term = sanitized_search_term
  end

  def sanitized_search_term
    params[:term].to_s.strip.downcase
  end

  def valid_search_term?(term)
    term.present? && term.length <= SearchTerm::MAX_TERM_LENGTH
  end

  def handle_valid_search_term
    session_id = session.id.to_s
    last_typed_term = params[:last_typed_term]
    SearchTerm.create_or_update(term: @term, session_id: session_id, last_typed_term: last_typed_term)
    render_search_response('success', @term)
  end

  def handle_invalid_search_term
    max_length = SearchTerm::MAX_TERM_LENGTH
    error_message = "Validation failed: Term is too long (maximum is #{max_length} characters)"
    render_error_response(error_message, :unprocessable_entity)
  end

  def render_search_response(status, term)
    render json: search_response_hash(status, term)
  end

  def render_error_response(message, status = :internal_server_error)
    render json: error_response_hash(message), status: status
  end

  def search_response_hash(status, term)
    {
      status: status,
      term: term,
      time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      popular_searches: SearchTerm.popular_searches
    }
  end

  def error_response_hash(message)
    { status: 'error', message: message }
  end
end
