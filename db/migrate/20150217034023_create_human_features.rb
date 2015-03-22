class CreateHumanFeatures < ActiveRecord::Migration
  def change
    create_table :human_features do |t|
    	t.integer :start_position
    	t.integer :stop_position
    	t.string :gene_symbol
    	t.string :refseq_transcript_name
    	t.integer :strand
    	t.integer :refseq_exon_position
    	t.integer :coding_start
    	t.integer :coding_stop
    	t.integer :human_transcript_id
    	t.boolean :canonical
      t.timestamps
    end
  end
end
