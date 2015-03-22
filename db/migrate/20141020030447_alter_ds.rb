class AlterDs < ActiveRecord::Migration
  def change
  	rename_column :ds_outputs, :type, :site_type
  end
end
