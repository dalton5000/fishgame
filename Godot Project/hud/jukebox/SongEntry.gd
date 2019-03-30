extends HBoxContainer

signal up_pressed
signal down_pressed

var active = true setget set_active
var song_id = -1 setget set_song_id

func set_active(slug):
	if slug:
#		$Play.show()
		$MoveDown.show()
		$MoveUp.hide()
	else:		
#		$Play.hide()
		$MoveDown.hide()
		$MoveUp.show()
#
func set_song_id(slug):
	song_id = slug
	$Title.text = "%s - %s" % [ music_data.songs[song_id]["song_name"], music_data.songs[song_id]["interpret"] ]

func _on_MoveUp_pressed():
	emit_signal("up_pressed")


func _on_MoveDown_pressed():
	emit_signal("down_pressed")
