class AddThirdColumns < ActiveRecord::Migration
  def change
  	add_column :genes,:first_third, :string
  	add_column :genes,:half, :string
  	add_column :genes,:second_third, :string
  	add_column :features,:first_third, :string
  	add_column :features,:half, :string
  	add_column :features,:second_third, :string
  end
end
