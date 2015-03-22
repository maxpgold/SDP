class AlterGeneGenome < ActiveRecord::Migration
  def change
  	add_column :genes, :genome_id, :integer
  	add_column :sites, :ds_output_id, :integer
  end
end
