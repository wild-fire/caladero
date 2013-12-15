class AddCategoryToPaper < ActiveRecord::Migration
  def change
    add_reference :papers, :category, index: true
  end
end
