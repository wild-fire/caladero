class CreateResearchQuestions < ActiveRecord::Migration
  def change
    create_table :research_questions do |t|
      t.string :question
      t.text :description

      t.timestamps
    end
  end
end
