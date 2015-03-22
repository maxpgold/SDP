class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :sequence
      t.string :loop_plus_two
      t.string :loop_plus_one
      t.string :loop
      t.string :strand
      t.integer :loop_start_position
      t.integer :start_position
      t.integer :end_position
      t.integer :strength
      t.string :type
      t.integer :r_value
      t.integer :c_value

      t.timestamps
    end
  end
end
