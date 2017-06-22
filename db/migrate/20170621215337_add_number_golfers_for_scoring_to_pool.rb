class AddNumberGolfersForScoringToPool < ActiveRecord::Migration
  def change
  	add_column :pools, :number_golfers_for_scoring, :integer, default: 5
  end
end
