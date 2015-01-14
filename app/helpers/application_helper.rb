module ApplicationHelper

  def number_to_score number
    number_with_precision number, precision: 2
  end

  def papers_score papers
    unread_papers = papers.reject(&:read)
    unread_papers.blank? ? -1 : unread_papers.map(&:score).max
  end
end
