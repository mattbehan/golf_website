# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "mattbehan@gmail.com", password: 'password', admin: true, first_name: "Matt", last_name: "Behan")
User.create(email: "fredericksjohnson@gmail.com", password: 'password', admin: true, first_name: "Freddy", last_name: "Johnson")

@tournament = Tournament.create(name: "seed test tournament - US Open", 
	url: "http://www.pgatour.com/tournaments/us-open/field.html", status: "upcoming",
	start_date_and_time: "2017-06-15 06:15:00", end_date_and_time: "2017-06-18 19:15:00",
	strokes_per_round_to_par: 72)
@tournament2 = Tournament.create(name: "seed test tournament - Travelers Championship", 
	url: "http://www.pgatour.com/tournaments/travelers-championship/field.html", status: "upcoming",
	start_date_and_time: "2017-06-22 06:15:00", end_date_and_time: "2017-06-25 19:15:00",
	strokes_per_round_to_par: 72) 

@tournament.initialize_pga_tournament_info
@tournament2.initialize_pga_tournament_info

# Golfer.create(first_name: "Thomas", last_name: "Aiken", pga_player_id: 24461, pga_profile_url: "http://www.pgatour.com/players/player.24461.thomas-aiken.html")
# Golfer.create(first_name: "Tyson", last_name: "Alexander", pga_player_id: 33408, pga_profile_url: "http://www.pgatour.com/players/player.33408.tyson-alexander.html")

# TournamentGolfer.create(golfer_id: 1, tournament_id: 1)
# TournamentGolfer.create(golfer_id: 2, tournament_id: 1)

Pool.create(creator_id: 1, name: 'seed test pool - Travelers Championship', tournament_id: @tournament2.id, 
	password: "jacksonian", number_golfers_for_scoring: 5)

PoolParticipant.create(pool_id: 1, user_id: 1)
7.times do
	Pick.create(user_id: 1, pool_id: 1, pool_participant_id: 1);
end




