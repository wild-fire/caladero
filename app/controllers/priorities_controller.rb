class PrioritiesController < ApplicationController

  def index
  end

  def show
    @priority = params[:id]

    render_404 unless Paper.priority.values.include? @priority

    @papers_with_categories = Paper.includes(:category). # We get all the papers wit its category
      prioritized_as(params[:id]). # Filter for the current priority
        order(score: :desc). # Order them by score
        group_by(&:category). # Then group by category
        sort_by do |category, papers| # and sort
          unread_papers = papers.reject(&:read)
          unread_papers.blank? ? -1 : unread_papers.map(&:score).max # We sort the categories for the maximum score of its unread papers (or -1 if there's no unread paper)
        end.reverse # and finally reverse the sort

  end

end
