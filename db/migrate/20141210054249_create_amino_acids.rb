class CreateAminoAcids < ActiveRecord::Migration
  def change
    create_table :amino_acids do |t|
    	t.string :amino_acid_symbol
    	t.string :amino_acid_letter

      t.timestamps
    end
  end
end
