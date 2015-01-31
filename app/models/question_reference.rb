class QuestionReference < ActiveRecord::Base
  belongs_to :paper
  belongs_to :research_question, inverse_of: :question_references

  attr_accessor :new_category

  before_save :save_new_category

  def paper_title
    paper.title unless paper.blank?
  end

  def new_category
    @new_category || self.category
  end

  def save_new_category
    self.category = self.new_category if self.category.blank?
  end

  rails_admin do
    visible false

    object_label_method do
      :paper_title
    end

    nested do
      field :paper
      field :category, :enum do
        enum do
          QuestionReference.pluck(:category).uniq.compact + ['']
        end
      end
      field :new_category
      field :details, :ck_editor
    end

  end

end
