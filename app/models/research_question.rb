class ResearchQuestion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :question, use: :slugged

  has_many :question_references, inverse_of: :research_question
  accepts_nested_attributes_for :question_references, :allow_destroy => true

  rails_admin do

    configure :question_references do
      inline_add true
    end

    object_label_method do
      :question
    end

    list do
      sort_by :question
      field :question
    end

    edit do
      field :question
      field :description, :ck_editor
      field :question_references
    end

    show do
      field :question
      field :description
    end

  end

end
