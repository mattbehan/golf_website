class Pick < ActiveRecord::Base
	belongs_to :user
	belongs_to :pool
	belongs_to :golfer
	belongs_to :pool_participant

	def golfers_calculated_total_score
		TournamentGolfer.find_by(golfer_id: self.golfer_id, tournament_id: self.pool.tournament_id).tournament_total_score
	end

	def golfers_total
		@tournament_golfer = TournamentGolfer.find_by(golfer_id: self.golfer_id, tournament_id: self.pool.tournament_id)
		if @tournament_golfer
			@tournament_golfer.total
		else
			"unknown"
		end
	end
end
