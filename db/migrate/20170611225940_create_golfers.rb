class CreateGolfers < ActiveRecord::Migration
  def change
    create_table :golfers do |t|
    	t.string :first_name, null: false
    	t.string :last_name, null: false
    	t.string :pga_player_id, null: false
    	t.string :pga_profile_url, null: false

      t.timestamps null: false
    end
  end
end
