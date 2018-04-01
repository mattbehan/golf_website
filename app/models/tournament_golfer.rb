class TournamentGolfer < ActiveRecord::Base
	belongs_to :tournament
	belongs_to :golfer
	has_many :rounds, dependent: :destroy

	def tournament_total_score
		rounds.pluck(:total_strokes).sum
	end
end
