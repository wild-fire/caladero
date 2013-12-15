class AddScoreToPaper < ActiveRecord::Migration
  def change
    add_column :papers, :score, :float, default: 0
  end
end
