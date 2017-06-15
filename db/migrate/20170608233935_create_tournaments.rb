class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|

	t.string :name, null: false, index: true
	t.string :url, null: false
	t.string :status, null: false, default: "upcoming"
	
      t.timestamps null: false
    end
  end
end
