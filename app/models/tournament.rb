require 'nokogiri'
require 'open-uri'
require 'watir'
# require 'phantomjs'
# if Rails.env.development?
# 	# Selenium::WebDriver::PhantomJS.path = "bin/phantomjs-mac"
# 	chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"bin","chromedriver-mac")
# 	puts chromedriver_path
# 	Selenium::WebDriver::Chrome.driver_path = chromedriver_path
# elsif Rails.env.production?
# 	# Selenium::WebDriver::PhantomJS.path = "bin/phantomjs-ubuntu"
# 	# chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"bin","chromedriver-linux")
# 	# Selenium::WebDriver::Chrome.driver_path = chromedriver_path
# end

if Rails.env.production?
	chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
	Selenium::WebDriver::Chrome.path = chrome_bin
end

# chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)

# chrome_opts = chrome_bin ? { "chromeOptions" => { "binary" => chrome_bin } } : {}

class Tournament < ActiveRecord::Base
	has_many :pools
	has_many :tournament_golfers
	has_many :golfers, through: :tournament_golfers
	has_many :rounds, through: :tournament_golfers

	validates_inclusion_of :status, :in => ["upcoming", "completed", "ongoing", "preparing"]

	validates :name, :url, presence: true


	def initialize_pga_tournament_info
		browser = Watir::Browser.new :chrome, headless: true
		browser.goto url
		doc = Nokogiri::HTML.parse(browser.html)
		# options = Selenium::WebDriver::Chrome::Options.new
		# options.add_argument('--headless')
		# driver = Selenium::WebDriver.for :chrome, options: options
		# player_blocks = driver.find_elements(:css, ".player-block")
		# puts player_blocks
		doc.css(".player-block").each do |player_block|
			puts 'in player block'
			css_golfer_id = player_block.css("img.player-img").attribute("id").value
			golfer_id = css_golfer_id.gsub("player-", "")
			@golfer = Golfer.find_by(pga_player_id: golfer_id)
			@tournament_golfer = nil
			puts @golfer
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
			next if !@tournament_golfer
			4.times do |x|
				Round.create(round_number: x+1, tournament_golfer_id: @tournament_golfer.id)
			end
		end
		self.update(instantiated?: true)
		browser.close
		return true
	end

	def update_current_pga_tournament_info
		browser = Watir::Browser.new :chrome, headless: true
		browser.goto "http://www.pgatour.com/leaderboard.html"
		doc = Nokogiri::HTML.parse(browser.html)
		# rows = doc.css(".leaderboard-main-content").xpath("div[starts-with(@class, 'player-row-')]")
		doc.css(".leaderboard-item").each do |row|
			pga_player_id = row.attribute("data-pid").value
			@golfer = Golfer.find_by(pga_player_id: pga_player_id)
			# necessary to wrap update logic in an if statment, only executes when golfer is found
			# this saves the case when the substitute player cannot be found
			# a more complete solution is to instantiate a new golfer and tournament golfer if this guy doesnt exist
			if @golfer
				@tournament_golfer = TournamentGolfer.find_by(golfer_id: @golfer.id, tournament_id: self.id)
				round_counter = 1
				next if !@tournament_golfer
				@tournament_golfer.update(total: row.css(".col-total").text.strip)
				row.css(".col-r").each do |round_data|
					@round = Round.find_by(round_number: round_counter, tournament_golfer_id: @tournament_golfer.id)
					if @round
						@round.update(total_strokes: round_data.text.strip.to_i) 
					end
					round_counter += 1
				end
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
