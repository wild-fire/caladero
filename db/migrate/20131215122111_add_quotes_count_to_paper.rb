class AddQuotesCountToPaper < ActiveRecord::Migration
  def change
    add_column :papers, :quotes_count, :integer
  end
end
