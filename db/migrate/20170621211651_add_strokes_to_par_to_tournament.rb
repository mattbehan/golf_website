class AddStrokesToParToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :strokes_per_round_to_par, :integer
  end
end
