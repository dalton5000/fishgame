extends PopupPanel

var sound_mute = false
var music_mute = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused =! get_tree().paused
		if get_tree().paused: show()
		else: hide()



func _on_Continue_button_up():
	get_tree().paused = false
	hide()


func _on_Restart_button_up():
	get_tree().reload_current_scene()

func _on_Music_button_up():
	music_mute = !music_mute
	AudioServer.set_bus_mute(1,music_mute)


func _on_Sound_button_up():
	sound_mute = !sound_mute
	AudioServer.set_bus_mute(2,sound_mute)
