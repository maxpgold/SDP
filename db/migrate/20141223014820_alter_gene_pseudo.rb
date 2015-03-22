class AlterGenePseudo < ActiveRecord::Migration
  def change
  	add_column :genes, :pseudo_gene, :boolean
  end
end
