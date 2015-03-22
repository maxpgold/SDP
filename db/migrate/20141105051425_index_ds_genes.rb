class IndexDsGenes < ActiveRecord::Migration
  def change
  	add_index :ds_output_genes, ["gene_id", "ds_output_id"]
  end
end
