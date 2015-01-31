class AddCategoryToQuestionReference < ActiveRecord::Migration
  def change
    add_column :question_references, :category, :string
  end
end
