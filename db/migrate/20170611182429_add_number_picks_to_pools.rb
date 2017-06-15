class AddNumberPicksToPools < ActiveRecord::Migration
  def change
  	add_column :pools, :number_picks, :integer, null: false, default: 7
  end
end
