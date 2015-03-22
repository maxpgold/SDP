class CreateStemLoops < ActiveRecord::Migration
  def change
    create_table :stem_loops do |t|
    	t.integer :loop_start_position
    	t.string :strand
    	t.integer :r_value
    	t.integer :gene_id
    	t.integer :feature_id
    	t.string :genome_id
    	t.integer :strength

      t.timestamps
    end
  end
end
