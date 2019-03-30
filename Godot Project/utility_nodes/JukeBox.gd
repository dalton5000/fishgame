extends Node

var current_song_id = 0

var song_queue = []


func _ready():
	play_random_song()
	for child in get_children():
		child.connect("finished",self,"play_next_song")

func song_finished():
	play_next_song()
		
func play_next_song():
	if music_data.song_queue.size() > 0:
		var current_song_id = music_data.song_queue[0]
		get_child(current_song_id).play()
		music_data.song_queue.erase(current_song_id)
		if helper.game:
			var titlemessage = "Playing: %s - %s" %[ music_data.songs[current_song_id]["song_name"], music_data.songs[current_song_id]["interpret"] ]
			helper.game.log_message(titlemessage)
	else:
		play_random_song()
		
func play_random_song():
	get_child(current_song_id).stop()
	randomize()
	var r_id = -1
	match music_data.active_songs.size():
		0:
			pass
		1:
			r_id = music_data.active_songs[0]
			current_song_id = r_id
		_:
			while true:
				r_id = randi()%music_data.active_songs.size()
				if r_id != current_song_id:
					current_song_id = music_data.active_songs[r_id]
					break
	if r_id != -1:
		get_child(current_song_id).play()
		if helper.game:
			var titlemessage = "Playing: %s - %s" %[ music_data.songs[current_song_id]["song_name"], music_data.songs[current_song_id]["interpret"] ]
			helper.game.log_message(titlemessage)
	