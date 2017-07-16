require 'nokogiri'
require 'open-uri'
require 'watir'
require 'phantomjs'
# chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"browsers","chromedriver.exe")
Selenium::WebDriver::PhantomJS.path = "bin/phantomjs"

class Tournament < ActiveRecord::Base
	has_many :pools
	has_many :tournament_golfers
	has_many :golfers, through: :tournament_golfers
	has_many :rounds, through: :tournament_golfers

	validates_inclusion_of :status, :in => ["upcoming", "completed", "ongoing", "preparing"]

	validates :name, :url, presence: true

	def initialize_pga_tournament_info
		browser = Watir::Browser.new :phantomjs
		browser.goto url
		doc = Nokogiri::HTML.parse(browser.html)
		doc.css(".player-block").each do |player_block|
			css_golfer_id = player_block.css("img.player-img").attribute("id").value
			golfer_id = css_golfer_id.gsub("player-", "")
			@golfer = Golfer.find_by(pga_player_id: golfer_id)
			@tournament_golfer = nil
			if !@golfer
				name_text = player_block.css(".player-name").text
				matches = name_text.match(/(\w+),\s*(\w+)/)
				first_name = matches[2]
				last_name = matches[1]
				profile_url = "http://www.pgatour.com/players/player.#{golfer_id}." + first_name.gsub(".", "-") + "-" + last_name.gsub(".", "-") + ".html"
				@golfer = Golfer.create(pga_player_id: golfer_id, first_name: first_name, last_name: last_name, pga_profile_url: profile_url)
				@tournament_golfer = TournamentGolfer.create(golfer_id: @golfer.id, tournament_id: self.id)
			elsif TournamentGolfer.where(golfer_id: @golfer.id, tournament_id: self.id).empty?
				@tournament_golfer = TournamentGolfer.create(golfer_id: @golfer.id, tournament_id: self.id)
			end
			4.times do |x|
				Round.create(round_number: x+1, tournament_golfer_id: @tournament_golfer.id)
			end
		end
		self.update(instantiated?: true)
		browser.close
		return true
	end

	def update_current_pga_tournament_info
		browser = Watir::Browser.new :phantomjs
		browser.goto "http://www.pgatour.com/leaderboard.html"
		doc = Nokogiri::HTML.parse(browser.html)
		# rows = doc.css(".leaderboard-main-content").xpath("div[starts-with(@class, 'player-row-')]")
		doc.css(".leaderboard-item").each do |row|
			pga_player_id = row.attribute("data-pid").value
			@golfer = Golfer.find_by(pga_player_id: pga_player_id)
			@tournament_golfer = TournamentGolfer.find_by(golfer_id: @golfer.id, tournament_id: self.id)
			round_counter = 1
			@tournament_golfer.total = row.css(".col-total")
			row.css(".col-r").each do |round_data|
				@round = Round.find_by(round_number: round_counter, tournament_golfer_id: @tournament_golfer.id)
				if @round
					@round.update(total_strokes: round_data.text.strip.to_i) 
				end
				round_counter += 1
			end
		end
		browser.close
		return true

	end

	def self.instantiate_tournaments
		@uninstantiated_tournaments = Tournament.where(instantiated?: false)
		@uninstantiated_tournaments.each do |tournament|
			tournament.initialize_pga_tournament_info
			tournament.update(instantiated?: true)
		end
	end

	def self.update_statuses
		current_time = Time.current.strftime("%Y-%m-%d %H:%M:%S")
		current_date = Time.current.strftime("%Y-%m-%d")
		Tournament.where.not(status: "completed").each do |tournament|
			tournaments_start_time = tournament.start_date_and_time.strftime("%Y-%m-%d %H:%M:%S")
			tournaments_start_date = tournament.start_date_and_time.strftime("%Y-%m-%d")
			tournaments_end_time = tournament.end_date_and_time.strftime("%Y-%m-%d %H:%M:%S")
			if tournament.status == "upcoming" || tournament.status == "preparing"
				if tournaments_start_time <= current_time
					tournament.update(status: "ongoing")
				elsif tournaments_start_date == current_date
					tournament.update(status: "preparing")
				end					
			elsif tournament.status == "ongoing"
				if tournaments_end_time <= current_date
					tournament.update(status: "completed")
				end
			end
		end
	end

	def self.update_ongoing
		Tournament.where(status: "ongoing").each do |tournament|
			tournament.update_current_pga_tournament_info
		end
	end


end
