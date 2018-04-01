class Pool < ActiveRecord::Base
	belongs_to :creator, class_name: :User
	belongs_to :tournament
	has_many :tournament_golfers, through: :tournament
	has_many :golfers, through: :tournament_golfers
	has_many :pool_participants

	# validates_inclusion_of :pool_type, :in => ["NFL", "PGA", "NBA", "NHL", "MLB"]
	validates :name, :tournament_id, presence: true

	def sort_pool_participants_by_score
		@disqualified_participants = []
		@scored_participants = []
		if pool_participants.count > 1
			pool_participants.each do |participant|
			participant.total_score.is_a?(Integer) ? @scored_participants.push(participant) : @disqualified_participants.push(participant)
			end
			if @scored_participants.count > 1
				@scored_participants = @scored_participants.sort_by {|a| a.total_score}
			end
			if @disqualified_participants.count > 0
				@scored_participants += @disqualified_participants
			end
		else
			@scored_participants = pool_participants
		end
		@scored_participants
	end
end
