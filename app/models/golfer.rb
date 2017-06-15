class Golfer < ActiveRecord::Base
	has_many :picks
	has_many :tournament_golfers
	has_many :tournaments, through: :tournament_golfers

	validates :first_name, :last_name, :pga_player_id, :pga_profile_url, presence: true

	def full_name
		first_name + " " + last_name
	end
end
