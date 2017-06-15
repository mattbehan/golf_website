class CreateTournamentGolfers < ActiveRecord::Migration
  def change
    create_table :tournament_golfers do |t|
    	t.references :tournament, null: false, index: true
    	t.references :golfer, null: false, index: true

      t.timestamps null: false
    end
  end
end
