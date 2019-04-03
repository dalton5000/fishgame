extends PanelContainer

onready var playlist = $VBoxContainer/Playlist
onready var disabled_list = $VBoxContainer/DisabledList

onready var song_entry_scene = preload("res://hud/jukebox/SongEntry.tscn")
onready var hidden_song_entry_scene = preload("res://hud/jukebox/HiddenSongEntry.tscn")

var expanded = false
onready var start_pos = rect_position
onready var size = rect_size

func reload():
	clear_lists()
	
	for song_id in music_data.unlocked_songs:
		if song_id in music_data.active_songs:
			var entry = song_entry_scene.instance()
			entry.set_active(true)
			entry.song_id = song_id
			playlist.add_child(entry)
			entry.connect("down_pressed",self,"_on_song_down_pressed", [song_id])
		else:			
			var entry = song_entry_scene.instance()
			entry.set_active(false)
			entry.song_id = song_id
			disabled_list.add_child(entry)
			
			entry.connect("up_pressed",self,"_on_song_up_pressed", [song_id])
			#create disabled
	for k in music_data.songs.size() - music_data.unlocked_songs.size():
		var entry = hidden_song_entry_scene.instance()
		playlist.add_child(entry)

func clear_lists():
	for list in [playlist, disabled_list]:
		for child in list.get_children():
			child.queue_free()
			

func _on_song_down_pressed(song_id):
	music_data.active_songs.erase(song_id)
	game_data.save_game()
	reload()
	
func _on_song_up_pressed(song_id):
	music_data.active_songs.append(song_id)
	game_data.save_game()
	reload()
	
func _ready():
	reload()

func expand():
	reload()
	var end_pos = start_pos
	end_pos.y -= size.y +40
	
	$MoveTween.interpolate_property(self,"rect_position",start_pos,end_pos,0.3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")
	expanded = true
	$VBoxContainer/HBoxContainer/Show.text = "Hide"
	
func collapse():
	$MoveTween.interpolate_property(self,"rect_position",rect_position,start_pos,0.3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$MoveTween.start()
	yield($MoveTween,"tween_completed")
	expanded = false
	$VBoxContainer/HBoxContainer/Show.text = "Show"
	

func _on_Show_pressed():
	if not $MoveTween.is_active():
		if expanded:
			collapse()
		else:
			expand()

func _on_Skip_pressed():
	$JukeBox.play_random_song()