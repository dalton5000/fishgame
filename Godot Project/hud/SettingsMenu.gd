extends PopupPanel

signal reset_game

const MUSIC_BUS = 1
const SOUND_BUS = 2
const AMBIENCE_BUS = 4

onready var music_button = $MarginContainer/VBoxContainer/MusicPanel/HBoxContainer/MusicToggle
onready var sound_button = $MarginContainer/VBoxContainer/SFXPanel/HBoxContainer2/SoundToggle
onready var ambience_button = $MarginContainer/VBoxContainer/AmbiencePanel/HBoxContainer2/AmbienceToggle

var initialized = false

func _ready():
	yield(get_tree(),"idle_frame")
	var db = linear2db(float(game_data.master_volume) / 10.0 )
	print("LADING DB: " + str(game_data.master_volume))
	AudioServer.set_bus_volume_db(0,db)
	
	AudioServer.set_bus_mute(MUSIC_BUS,game_data.music_muted)
	AudioServer.set_bus_mute(SOUND_BUS,game_data.sound_muted)
	AudioServer.set_bus_mute(AMBIENCE_BUS,game_data.ambience_muted)
	
	$MarginContainer/VBoxContainer/VolumePanel/HBoxContainer/VolumeSlider.value = int(game_data.master_volume)
	
	$MarginContainer/VBoxContainer/MusicPanel/HBoxContainer/MusicToggle.text = "OFF" if game_data.music_muted else "ON"
	$MarginContainer/VBoxContainer/MusicPanel/HBoxContainer/MusicToggle.pressed = false if game_data.music_muted else true
	$MarginContainer/VBoxContainer/AmbiencePanel/HBoxContainer2/AmbienceToggle.text = "OFF" if game_data.ambience_muted else "ON"
	$MarginContainer/VBoxContainer/AmbiencePanel/HBoxContainer2/AmbienceToggle.pressed = false if game_data.ambience_muted else true
	$MarginContainer/VBoxContainer/SFXPanel/HBoxContainer2/SoundToggle.text = "OFF" if game_data.sound_muted else "ON"
	$MarginContainer/VBoxContainer/SFXPanel/HBoxContainer2/SoundToggle.pressed = false if game_data.sound_muted else true
	initialized = true
func _on_SettingsMenu_about_to_show():
	get_tree().paused = true


func _on_SettingsMenu_popup_hide():
	get_tree().paused = false
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("pause"):
			print(event)
			if visible:
				hide()
			else:
				popup()

#servers: 0 master, 1 music, 2 sound, 3 spinner, 4ambience
func _on_MusicToggle_toggled(button_pressed):
	if initialized:
		AudioServer.set_bus_mute(1,!button_pressed)
		game_data.music_muted=!button_pressed
		if button_pressed:
			$MarginContainer/VBoxContainer/MusicPanel/HBoxContainer/MusicToggle.text = "ON"
		else:
			$MarginContainer/VBoxContainer/MusicPanel/HBoxContainer/MusicToggle.text = "OFF"

func _on_AmbienceToggle_toggled(button_pressed):
	if initialized:
		AudioServer.set_bus_mute(4,!button_pressed)
		game_data.ambience_muted=!button_pressed
		if button_pressed:
			$MarginContainer/VBoxContainer/AmbiencePanel/HBoxContainer2/AmbienceToggle.text = "ON"
		else:
			$MarginContainer/VBoxContainer/AmbiencePanel/HBoxContainer2/AmbienceToggle.text = "OFF"



func _on_SoundToggle_toggled(button_pressed):
	if initialized:
		AudioServer.set_bus_mute(2,!button_pressed)
		game_data.sound_muted=!button_pressed
		if button_pressed:
			$MarginContainer/VBoxContainer/SFXPanel/HBoxContainer2/SoundToggle.text = "ON"
		else:
			$MarginContainer/VBoxContainer/SFXPanel/HBoxContainer2/SoundToggle.text = "OFF"

func _on_Close_pressed():
	hide()

func _on_VolumeSlider_value_changed(value):
	if initialized:
		game_data.master_volume = value
		var db = linear2db(float(value) / 10.0 )
		AudioServer.set_bus_volume_db(0,db)


func _on_ResetButton_pressed():
	emit_signal("reset_game")
#	yield(get_tree(), "idle_frame")
#	get_tree().reload_current_scene()
