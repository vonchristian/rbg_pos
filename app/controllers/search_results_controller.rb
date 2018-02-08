class SearchResultsController < ApplicationController
  def index
    @pg_search_documents = PgSearch.multisearch(params[:sidebar_search])
  end
end
