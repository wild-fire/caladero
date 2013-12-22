module ApplicationHelper

  def number_to_score number
    number_with_precision number, precision: 2
  end
end
