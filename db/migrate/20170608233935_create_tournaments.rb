class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|

	t.string :name, null: false, index: true
	t.string :url, null: false
	t.string :status, null: false, default: "upcoming"
	t.integer :number_of_rounds, null: false
	t.datetime :start_date_and_time, null: false
	t.boolean :instantiated?, default: false
	t.datetime :end_date_and_time, null: false
	
      t.timestamps null: false
    end
  end
end
