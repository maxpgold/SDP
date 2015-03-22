class AlterGene < ActiveRecord::Migration
  def change
  	add_column :genes, :hypothetical, :boolean
  end
end
