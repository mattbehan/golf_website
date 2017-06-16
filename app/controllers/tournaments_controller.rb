class TournamentsController < ApplicationController

	before_action :must_be_admin, except: [:show, :index]

	def index
		@tournaments = Tournament.all
	end

	def new
		@tournament = Tournament.new
	end

	def create
		@tournament = Tournament.new(tournament_params)
		if @tournament.save
			redirect_to @tournament
		else
			@tournament_errors = @tournament.errors.full_messages
			flash[:errors] = @tournament_errors
      		redirect_to new_tournament_path
      	end
	end

	def show
		@tournament = Tournament.find(params[:id])
	end

	def edit
		@tournament = Tournament.find(params[:id])
	end


	def update
		@tournament = Tournament.find(params[:id])
		if @tournament.update_attributes(tournament_params)
			redirect_to @tournament
		else
			flash[:errors] = @tournament.errors.full_messages
			redirect_to edit_tournament_path
		end
	end

	def destroy
	end

	def initialize_data_after_create
		@tournament.initialize_pga_tournament_info
	end


	private

	def tournament_params
		params.require(:tournament).permit(:name, :url)
	end

end
