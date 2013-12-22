class AuthorsController < ApplicationController

  def index
    @authors = Author.order(:name)
  end

  def show
    @author = Author.includes(papers: :category).find(params[:id])
    @papers_with_categories = @author.papers.order(score: :desc).group_by(&:category)
  end

end
