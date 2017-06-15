class Tournament < ActiveRecord::Base
	has_many :pools
	has_many :tournament_golfers
	has_many :golfers, through: :tournament_golfers

	validates_inclusion_of :status, :in => ["upcoming", "completed", "ongoing"]

	validates :name, :url, presence: true
end
