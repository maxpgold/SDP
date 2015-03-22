class CreateHumanTranscripts < ActiveRecord::Migration
  def change
    create_table :human_transcripts do |t|
    	t.string :refseq_transcript_name
    	t.integer :chromosome_id
    	t.integer :strand
    	t.integer :start_position
    	t.integer :stop_position
    	t.integer :coding_start
    	t.integer :coding_stop
    	t.string :symbol
    	t.integer :human_gene_id
    	t.boolean :canonical
      t.timestamps
    end
  end
end
