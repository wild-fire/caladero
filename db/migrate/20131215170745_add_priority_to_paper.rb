class AddPriorityToPaper < ActiveRecord::Migration
  def change
    add_column :papers, :priority, :integer
  end
end
