class AddSessionIdToSearchTerms < ActiveRecord::Migration[7.1]
  def change
    add_column :search_terms, :session_id, :string
  end
end
