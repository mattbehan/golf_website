class AddPasswordToPools < ActiveRecord::Migration
  def change
  	add_column :pools, :password, :string
  end
end
