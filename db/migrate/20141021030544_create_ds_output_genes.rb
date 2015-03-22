class CreateDsOutputGenes < ActiveRecord::Migration
  def change
    create_table :ds_output_genes do |t|
    	t.integer :gene_id
    	t.integer :ds_output_id

      t.timestamps
    end
  end
end
