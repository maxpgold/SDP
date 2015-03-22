class AlterSiteA < ActiveRecord::Migration
  def change
  	rename_column :sites, :loop, :loop_seq
  	add_column :sites, :genome_id, :integer
  	add_column :ds_outputs, :genome_id, :integer
  end
end
