class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
    	t.integer :start_position
    	t.integer :end_position
    	t.string :strand
    	t.string :feature_type
      t.timestamps
    end
  end
end
