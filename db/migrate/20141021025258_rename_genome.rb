class RenameGenome < ActiveRecord::Migration
  def change
  	rename_column :genomes, :type, :genome_type
  end
end
