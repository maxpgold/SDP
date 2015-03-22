class AlterFeatureDs < ActiveRecord::Migration
  def change
  	add_column :ds_outputs, :feature_id, :integer
  end
end
