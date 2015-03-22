class AlterFeature < ActiveRecord::Migration
  def change
  	add_column :features, :gene_id, :integer
  end
end
