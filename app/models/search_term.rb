class SearchTerm < ApplicationRecord
  MAX_TERM_LENGTH = 255

  validates :term, presence: true, length: { maximum: MAX_TERM_LENGTH }

  scope :popular_searches, -> { group(:term).order('count_term DESC').limit(5).count('term') }

  def self.create_or_update(term, session_id)
    existing_search = find_by(session_id: session_id)

    if existing_search
      existing_search.update(term: term)
    else
      create(term: term, session_id: session_id)
    end
  end
end
