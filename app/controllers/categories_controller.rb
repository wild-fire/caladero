class CategoriesController < ApplicationController

  def index
    @categories = Category.order(score: :desc)
  end

  def show
    @category = Category.includes(:papers).find(params[:id])
    @papers_with_priorities = @category.papers.order(priority: :desc).group_by(&:priority)
  end
end
