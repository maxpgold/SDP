class AddHbCodon < ActiveRecord::Migration
  def change
  	add_column :sites,:hb_codon, :string
  end
end
