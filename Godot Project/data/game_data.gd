extends Node

signal loaded

var player_name = "" setget set_player_name
var player_money = 0 setget set_player_money
var last_ranked = 1 setget set_last_ranked

#settings

#audio
var master_volume = 1.0 setget set_master_volume
var music_muted = false setget set_music_muted
var sound_muted = false setget set_sound_muted
var ambience_muted = false setget  set_ambience_muted



func _ready():
	load_config()

func set_master_volume(slug):
	master_volume = slug
	save_config()

func set_music_muted(slug):
	music_muted = slug
	save_config()
	
func set_sound_muted(slug):
	sound_muted = slug
	save_config()
	
func set_ambience_muted(slug):
	ambience_muted = slug
	save_config()
	
func save_config():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		config.set_value("player", "money", player_money)
		config.set_value("player", "name", player_name)
		config.set_value("player", "last_ranked", last_ranked)
		
		config.set_value("audio", "master_volume", master_volume)		
		config.set_value("audio", "music_muted", music_muted)
		config.set_value("audio", "sound_muted", sound_muted)
		config.set_value("audio", "ambience_muted", ambience_muted)
	helper.log_message("saving config with error code: %s" % err)
	config.save("user://settings.cfg")

func load_config():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == 0:
		player_money = config.get_value("player","money",player_money)
		player_name = config.get_value("player","name","error client")
		last_ranked = config.get_value("player","last_ranked",player_money)
		
		master_volume = config.get_value("audio", "master_volume", master_volume)
		music_muted = config.get_value("audio", "music_muted", music_muted)
		sound_muted =  config.get_value("audio", "sound_muted", sound_muted)
		ambience_muted = config.get_value("audio", "ambience_muted", ambience_muted)
		
		print("last rank:" + str(last_ranked))
	helper.log_message("loading config with error code: %s" % err)
	emit_signal("loaded")
	

func set_last_ranked(slug):
	last_ranked = slug
	save_config()

func set_player_money(slug):
	player_money = slug
	save_config()

func set_player_name(slug):
	player_name = slug
	save_config()
	
	