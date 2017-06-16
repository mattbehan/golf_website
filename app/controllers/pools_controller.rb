class PoolsController < ApplicationController

	before_action :must_be_logged_in, only: [:new, :create, :edit, :destroy, :show_join_pool, :join_pool]


	def show_join_pool
		@join_pool = Pool.new
	end

	def join_pool
		@pool = Pool.find(params[:id])
		# if user clicks on join pool and is not signed in then 
		# User clicks join pool button
		# If not signed in when clicking button, then they are redirected to login
		# If signed in, redirect them to join_pool
		# display form with password on join_pool - add custom validation for password checking
		# if the user has a valid email and password, then they are added to pool_participants and the pool.number_picks Picks are created for them, with the golfer blank, and they are redirectd to the pools pick page
		if params[:password] == @pool.password && !currently_participates_in_pool?(@pool.id)
			@pool_participant = PoolParticipant.create(user_id: current_user.id, pool_id: @pool.id)
			@pool.number_picks.times do
				Pick.create(pool_id: @pool.id, user_id: current_user.id, pool_participant_id: @pool_participant.id)
			end
			redirect_to pool_path(@pool)
		else
			flash[:errors] = "Either password incorrect or you are already a member of this pool"
			redirect_to show_join_pool_path(@pool)
		end
	end
  
	def index
		@users_pools = users_pools
		@owned_pools = owned_pools
		@all_pools = Pool.all
	end

	def new
		@pool = Pool.new
		@available_tournaments = Tournament.where(status: "upcoming")
	end

	def create
		@pool = Pool.new(pool_params)
		if @pool.save
			redirect_to @pool
		else
			@pool_errors = @pool.errors.full_messages
			flash[:errors] = @pool_errors
      		redirect_to new_pool_path
      	end
	end

	def show
		@pool = Pool.find(params[:id])
		@pool_participants = PoolParticipant.where(pool_id: @pool.id)
		@picks = user_signed_in? ? Pick.where(user_id: current_user.id, pool_id: @pool.id) : nil

	end

	def edit
		@pool = Pool.find(params[:id])
		must_be_owner(@pool.creator_id)
	end


	def update
		@pool = Pool.find(params[:id])
		must_be_owner(@pool.creator_id)
		if @pool.update_attributes(pool_params)
			redirect_to @pool
		else
			flash[:errors] = @pool.errors.full_messages
			redirect_to edit_pool_path
		end
	end

	def destroy
		Pool.destroy(params[:id])
		flash[:message] = "Pool " + params[:id] + " successfully deleted"
		redirect_to root_path
	end



	private

	def pool_params
		params.require(:pool).permit(:name, :creator, :pool_type, :tournament_id, :number_picks).merge(creator_id: current_user.id)
	end

end
