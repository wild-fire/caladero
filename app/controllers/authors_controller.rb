class AuthorsController < ApplicationController

  def index
    @authors = Author.order(:name)
  end

  def show
    @author = Author.includes(papers: :category).friendly.find(params[:id])
    @papers_with_priorities = @author.papers.order(priority: :desc).group_by(&:priority)
  end

end
