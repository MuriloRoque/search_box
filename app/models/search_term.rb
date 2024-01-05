class SearchTerm < ApplicationRecord
  MAX_TERM_LENGTH = 255

  validates :term, presence: true, length: { maximum: MAX_TERM_LENGTH }

  scope :popular_searches, -> { group(:term).order('count_term DESC').limit(5).count('term') }

  def self.create_or_update(term:, session_id:, last_typed_term:)
    existing_search = find_by(session_id: session_id)

    if should_update_search?(existing_search, term, last_typed_term)
      existing_search.update(term: term)
    else
      create(term: term, session_id: session_id)
    end
  end

  private

  def self.should_update_search?(existing_search, current_term, last_typed_term)
    last_typed_term_present?(last_typed_term) &&
      (last_typed_term_substring?(current_term, last_typed_term) || last_typed_term_substring?(last_typed_term, current_term))
  end

  def self.last_typed_term_present?(last_typed_term)
    last_typed_term.present?
  end

  def self.last_typed_term_substring?(term, last_typed_term)
    last_typed_term.present? && (term.include?(last_typed_term) || last_typed_term.include?(term))
  end
end
