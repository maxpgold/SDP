class CreateGenes < ActiveRecord::Migration
  def change
    create_table :genes do |t|
      t.string :name
      t.integer :start_position
      t.integer :end_position
      t.string :strand

      t.timestamps
    end
  end
end
