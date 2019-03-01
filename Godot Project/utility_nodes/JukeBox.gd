extends Node

func _ready():
#	play_random_song()
	$SongJohn.play()
	for child in get_children():
		child.connect("finished",self,"play_random_song")
	
func play_random_song():
	randomize()
	var r_id = randi()%get_child_count()
	get_child(r_id).play()
	