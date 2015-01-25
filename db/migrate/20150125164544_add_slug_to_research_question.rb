class AddSlugToResearchQuestion < ActiveRecord::Migration
  def change
    add_column :research_questions, :slug, :string
  end
end
