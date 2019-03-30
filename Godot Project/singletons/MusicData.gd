extends Node

var songs = [
	{
		"song_name" : "Lazy Day",
		"interpret" : "Jason Shaw",
		},
	{
		"song_name" : "12 Mornings",
		"interpret" : "Jason Shaw",
		},
	{
		"song_name" : "Green Leaves",
		"interpret" : "Jason Shaw",
		},
	{
		"song_name" : "Paper Wings",
		"interpret" : "Jason Shaw",
		},
	{
		"song_name" : "Good Morning",
		"interpret" : "Unwritten Stories",
		},
	{
		"song_name" : "I'm Alright",
		"interpret" : "Unwritten Stories",
		},
	{
		"song_name" : "Mechanical Birds",
		"interpret" : "Unwritten Stories",
		},
	{
		"song_name" : "Room For Two",
		"interpret" : "Dan Lebowitz",
		},
	{
		"song_name" : "The Clean-Up Man",
		"interpret" : "Dan Lebowitz",
		},
	{
		"song_name" : "Wave in the Atmosphere",
		"interpret" : "Dan Lebowitz",
		},
	{
		"song_name" : "Shattered Paths",
		"interpret" : "Akaash Ghandi",
		},
	{
		"song_name" : "White River",
		"interpret" : "Akaash Ghandi",
		}
	]
	
var unlocked_songs = [ 0, 1, 2, 3 ]
var active_songs = [ 0, 1, 2, 3 ]
var song_queue = []

func unlock_random_song():
	var r_id = -1
	
	if songs.size() > unlocked_songs.size():
		while true:
			r_id = randi()%songs.size()
			if not r_id in unlocked_songs:
				unlocked_songs.append(r_id)
				active_songs.append(r_id)
				song_queue.append(r_id)
				helper.log_message("Unlocked Song: %s - %s" % [songs[r_id]["interpret"], songs[r_id]["song_name"]])
				break
	return r_id
	
		