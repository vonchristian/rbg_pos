class SearchResultsController < ApplicationController
  def index
    @pg_search_documents = PgSearch.multisearch(params[:multisearch])
  end
end
