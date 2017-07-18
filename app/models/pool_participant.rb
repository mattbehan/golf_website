class PoolParticipant < ActiveRecord::Base
	belongs_to :user
	belongs_to :pool
	has_many :picks

	validates :user_id, :pool_id, presence: true

	def self.users_pools
		if !user_signed_in
			return nil
		else
			return PoolParticipant.where(user_id: current_user.id)
		end
	end

	# gets total score with respect to rules
	def total_score
		all_scores = picks.collect { |pick|
			picks_golfers = TournamentGolfer.where(golfer_id: pick.golfer_id, tournament_id: pick.pool.tournament_id).pluck(:total)[0].to_i
		}.sort
		all_scores[0..(pool.number_golfers_for_scoring-1)].sum
	end

	def calculated_total_score
		picks.collect { |pick|
			picks_golfers = TournamentGolfer.where(golfer_id: pick.golfer_id, tournament_id: pick.pool.tournament_id)
			picks_golfers.inject(0) {|sum, golfer| sum + golfer.tournament_total_score}
		}.sum
	end

	def tournament_golfers
		picks.collect {|pick| TournamentGolfer.where(golfer_id: pick.golfer_id, tournament_id: pick.pool.tournament_id)}
	end

	def picks_made?
		picks.all? {|pick| pick.golfer_id != nil}
	end

end
