class AddScoreToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :score, :float, default: 0
  end
end
