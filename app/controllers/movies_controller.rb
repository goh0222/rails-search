class MoviesController < ApplicationController
  def index
    if params[:query].present?
      # sql_query = <<~SQL
      #   movies.title @@ :query
      #   OR movies.synopsis @@ :query
      #   OR directors.first_name @@ :query
      #   OR directors.last_name @@ :query
      # SQL
      # @movies = Movie.joins(:director).where(sql_query, query: "%#{params[:query]}%")

      # use PgSearch to retrieve movie results
      results = PgSearch.multisearch(params[:query])
      @movies = []
      results.each do |result|
        @movies << Movie.find(result.searchable_id)
      end
    else
      @movies = Movie.all
    end
  end
end
