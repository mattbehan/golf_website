class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	helper_method :must_be_logged_in, :find_user, :must_be_owner, :owner?, :find_owner, :wipe_session, :user_exists?, :pool_creater, :currently_participates_in_pool?, :admin?, :must_be_admin

	def currently_participates_in_pool? (pool_id)
		user_signed_in? && !PoolParticipant.where(pool_id: pool_id, user_id: current_user.id).empty?
	end

	# needs to be tested
	def admin?	
		user_signed_in? && current_user.admin
	end

	def must_be_admin
		if !admin?
			redirect_to 'errors/not_admin'
		end
	end

	def user_exists?
		if @user == nil
			redirect_to "/users/unknown_user" 
		end
	end

	def users_pools
		if !user_signed_in?
			return nil
		else
			return PoolParticipant.where(user_id: current_user.id).map { |pool_participant| Pool.find(pool_participant.pool_id)}
		end
	end

	def owned_pools
		if !user_signed_in?
			return nil
		else
			return pools = Pool.where(creator_id: current_user.id)
		end
	end

	def wipe_session
		session.destroy
	end

	def find_owner(resource, resource_id)
		return @owner = resource_id.to_i if resource == "User"
		@resources_class = Object.const_get(resource)
		@owner = @resources_class.find_by(id: resource_id).user_id
	end

	def pool_creator(pool_id)
		return Pool.find(pool_id).creator
	end

	def must_be_owner resource_users_id
		unless owner?(resource_users_id)
			flash[:alert] = "You are not authorized to take that action"
			redirect_to :back
		end
	end

	def owner? resource_owners_id
		user_signed_in? && resource_owners_id.to_i == current_user.id
	end


	def find_user
		@user = User.find_by(id: params[:id])
	end

	def must_be_logged_in
		redirect_to new_user_session_path unless user_signed_in?
	end


end
