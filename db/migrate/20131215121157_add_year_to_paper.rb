class AddYearToPaper < ActiveRecord::Migration
  def change
    add_column :papers, :year, :integer
  end
end
