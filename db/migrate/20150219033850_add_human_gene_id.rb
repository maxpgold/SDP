class AddHumanGeneId < ActiveRecord::Migration
  def change
  	add_column :ds_outputs, :human_gene_id, :integer
  end
end
