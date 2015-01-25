class QuestionReference < ActiveRecord::Base
  belongs_to :paper
  belongs_to :research_question, inverse_of: :question_references

  def paper_title
    paper.title unless paper.blank?
  end

  rails_admin do
    visible false

    object_label_method do
      :paper_title
    end

  end

end
