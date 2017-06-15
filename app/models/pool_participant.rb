class PoolParticipant < ActiveRecord::Base
	belongs_to :user
	belongs_to :pool

	validates :user_id, :pool_id, presence: true

	def self.users_pools
		if !user_signed_in
			return nil
		else
			return PoolParticipant.where(user_id: current_user.id)
		end
	end

end
