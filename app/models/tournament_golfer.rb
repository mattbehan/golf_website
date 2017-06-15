class TournamentGolfer < ActiveRecord::Base
	belongs_to :tournament
	belongs_to :golfer
end
