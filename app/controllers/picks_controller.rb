class PicksController < ApplicationController

	respond_to :html, :js, :json

	# def index
	# 	@picks = Pick.all
	# end

	# def new
	# 	@pick = Pick.new
	# end

	# # bulk update picks, if any of the picks doesn't pass validation then return
	# def create
	# 	@pick = Pick.new(pick_params)
	# 	if @pick.save
	# 		redirect_to @pick
	# 	else
	# 		@pick_errors = @pick.errors.full_messages
	# 		flash[:errors] = @pick_errors
 #      		redirect_to new_pick_path
 #      	end
	# end

	# def show
	# 	@pick = Pick.find(params[:id])
	# 	@pick_participants = pickParticipant.where(pick_id: params[:id])
	# end

	# def edit
	# 	@pick = Pick.find(params[:id])
	# 	must_be_owner(@pick.user_id)
	# end


	def update
		@pick = Pick.find(params[:pick_id])
		must_be_owner(@pick.user_id)
		puts @pick.pool.tournament.status
		if @pick.pool.tournament.status != "upcoming"
			render :status => 403
		else
			if(params[:golfer_id])
				@pick.update(golfer_id: params[:golfer_id])
			end
			render :nothing => true
		end
	end

	def destroy
	end

	private

	# def pick_params
	# 	params.require(:pick).permit(:golfer_id, :user_id)
	# end
end