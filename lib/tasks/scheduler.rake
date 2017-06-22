desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Updating feed..."
  NewsFeed.update
  puts "done."
end

task :send_reminders => :environment do
  User.send_reminders
end

desc "Identify tournaments that need to have their statuses changed, update tournaments that are underway, and instantiate tournaments that are waiting to be instantiated"
task :update_tournaments => :environment do 
	puts "Updating tournaments that need to be instantiated ... "
	Tournament.instantiate_tournaments
	puts "done"
	puts "Preparing upcoming and completing old"
	Tournament.update_statuses
	puts "done"
	puts "Updating ongoing tournaments"
	Tournament.update_ongoing
	puts "done"
end