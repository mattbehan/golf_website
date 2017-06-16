# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever



# instantiate uninstantiated tournaments every 15 mins


# every 15.minutes do
# 	@uninstantiated_tournaments = Tournament.where(instantiated?: false)
# 	@uninstantiated_tournaments.each do |tournament|
# 		tournament.initialize_pga_tournament_info
# 		tournament.update(instantiated?: true)
# 	end
# end

# every 30.minutes do
# 	# check for upcoming tournaments and if time is greater than current time, set them to ongoing
# 	Tournament.where(status: "upcoming").each do |tournament|
# 		current_time = Time.current.strftime("%Y-%m-%d %H:%M:%S")
# 		if(tournament.start_date_and time <= current_time)
# 			tournament.update(status: "ongoing")
# 		end
# 	end
# 	# update ongoing tournaments
# 	Tournament.where(status: "ongoing").each do |tournament|
# 		tournament.update_current_pga_tournament_info
# 	end
# end



