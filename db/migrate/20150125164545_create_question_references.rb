class CreateQuestionReferences < ActiveRecord::Migration
  def change
    create_table :question_references do |t|
      t.belongs_to :paper, index: true
      t.belongs_to :research_question, index: true
      t.text :details

      t.timestamps
    end
  end
end
