require 'nokogiri'
require 'open-uri'
require 'watir'
# chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"browsers","chromedriver.exe")
# Selenium::WebDriver::Chrome.driver_path = chromedriver_path

class Tournament < ActiveRecord::Base
	has_many :pools
	has_many :tournament_golfers
	has_many :golfers, through: :tournament_golfers
	has_many :rounds, through: :tournament_golfers

	validates_inclusion_of :status, :in => ["upcoming", "completed", "ongoing"]

	validates :name, :url, presence: true

	def initialize_pga_tournament_info
		browser = Watir::Browser.new :chrome
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
			elsif TournamentGolfer.where(golfer_id: @golfer.id).empty?
				@tournament_golfer = TournamentGolfer.create(golfer_id: @golfer.id, tournament_id: self.id)
			end
			self.number_of_rounds.times do |x|
				Round.create(round_number: x+1, tournament_golfer_id: @tournament_golfer.id)
			end
		end
		browser.close
		return true
	end

	def update_current_pga_tournament_info
		browser = Watir::Browser.new :chrome
		browser.goto "http://www.pgatour.com/leaderboard.html"
		doc = Nokogiri::HTML.parse(browser.html)
		# rows = doc.css(".leaderboard-main-content").xpath("div[starts-with(@class, 'player-row-')]")
		doc.css(".leaderboard-item").each do |row|
			pga_player_id = row.attribute("data-pid").value
			@golfer = Golfer.find_by(pga_player_id: pga_player_id)
			@tournament_golfer = TournamentGolfer.find_by(golfer_id: @golfer.id, tournament_id: self.id)
			round_counter = 1
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


end
