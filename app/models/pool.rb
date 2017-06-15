class Pool < ActiveRecord::Base
	belongs_to :creator, class_name: :User
	belongs_to :tournament
	has_many :tournament_golfers, through: :tournament
	has_many :golfers, through: :tournament_golfers

	# validates_inclusion_of :pool_type, :in => ["NFL", "PGA", "NBA", "NHL", "MLB"]
	validates :name, :tournament_id, presence: true
end
