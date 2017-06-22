class AddTotalToTournamentGolfer < ActiveRecord::Migration
  def change
  	add_column :tournament_golfers, :total, :string
  end
end
