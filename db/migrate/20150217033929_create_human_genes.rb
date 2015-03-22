class CreateHumanGenes < ActiveRecord::Migration
  def change
    create_table :human_genes do |t|
    	t.integer :old_id
    	t.string :symbol
    	t.integer :start_position
    	t.integer :stop_position
    	t.integer :strand
    	t.integer :chromosome_id
      t.timestamps
    end
  end
end
