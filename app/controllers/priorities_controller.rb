class PrioritiesController < ApplicationController

  def index
  end

  def show
    @priority = params[:id]

    render_404 unless Paper.priority.values.include? @priority

    @papers_with_categories = Paper.includes(:category).prioritized_as(params[:id]).order(score: :desc).group_by(&:category)

  end

end