# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "mattbehan@gmail.com", password: 'password', admin: true)

Tournament.create(name: "seed test tournament - US Open", url: "http://www.pgatour.com/tournaments/us-open/field.html", status: "upcoming")

Golfer.create(first_name: "Thomas", last_name: "Aiken", pga_player_id: 24461, pga_profile_url: "http://www.pgatour.com/players/player.24461.thomas-aiken.html")
Golfer.create(first_name: "Tyson", last_name: "Alexander", pga_player_id: 33408, pga_profile_url: "http://www.pgatour.com/players/player.33408.tyson-alexander.html")

TournamentGolfer.create(golfer_id: 1, tournament_id: 1)
TournamentGolfer.create(golfer_id: 2, tournament_id: 1)

Pool.create(creator_id: 1, name: 'test1', tournament_id: 1, password: "jacksonian")

PoolParticipant.create(pool_id: 1, user_id: 1)
7.times do
	Pick.create(user_id: 1, pool_id: 1);
end