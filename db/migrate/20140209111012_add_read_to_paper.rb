class AddReadToPaper < ActiveRecord::Migration
  def change
    add_column :papers, :read, :boolean, default: false
  end
end
