class CreateDsOutputs < ActiveRecord::Migration
  def change
    create_table :ds_outputs do |t|
      t.string :sequence
      t.string :loop_plus_two
      t.string :loop_plus_one
      t.string :loop
      t.integer :loop_start_position
      t.integer :strength
      t.string :type
      t.integer :r_value
      t.timestamps
    end
  end
end
