class RemoveNumberOfRoundsFromTournament < ActiveRecord::Migration
  def change
  	remove_column :tournaments, :number_of_rounds
  end
end
