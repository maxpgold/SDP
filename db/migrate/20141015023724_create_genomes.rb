class CreateGenomes < ActiveRecord::Migration
  def change
    create_table :genomes do |t|
      t.string :name
      t.string :kingdom
      t.string :type
      t.timestamps
    end
  end
end
