class AlterDsOutput < ActiveRecord::Migration
  def change
  	rename_column :ds_outputs, :loop, :loop_seq
  end
end
