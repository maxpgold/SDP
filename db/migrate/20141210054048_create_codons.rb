class CreateCodons < ActiveRecord::Migration
  def change
    create_table :codons do |t|
    	t.string :symbol
    	t.string :amino_acid_symbol
    	t.string :amino_acid_letter
    	t.integer :amino_acid_id

      t.timestamps
    end
  end
end
