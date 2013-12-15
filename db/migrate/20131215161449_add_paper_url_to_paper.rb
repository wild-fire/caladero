class AddPaperUrlToPaper < ActiveRecord::Migration
  def change
    add_column :papers, :paper_url, :string
  end
end
