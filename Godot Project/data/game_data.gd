extends Node

signal loaded

var player_name = "" setget set_player_name
var player_money = 0 setget set_player_money
var last_ranked = 1 setget set_last_ranked

#settings

#audio
var master_volume = 0.0 setget set_master_volume
var music_muted = false setget set_music_muted
var sound_muted = false setget set_sound_muted
var ambience_muted = false setget  set_ambience_muted



func _ready():
	helper.log_message("gamedata ready")
#	yield(get_tree(),"idle_frame")
	load_config()
	load_game()

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

func reset_game():
	player_name = "Fisherman Fred"
	player_money = 0
	upgrade_data.initialize_upgrades_bought()
	last_ranked = -1
	save_game()
	
func load_game():
	helper.log_message("looking for savegame in %s" % str(OS.get_user_data_dir()))
	var save_file = File.new()
	var err = save_file.open("user://savegame.save", File.READ)
#	var err = save_file.open("user://savegame.save", File.READ)
	if err != 0:
		helper.log_message("no savegame found, creating new one")
		reset_game()
	else:
		var text_json = save_file.get_as_text()	
	
		var save_dict = JSON.parse(text_json).result
		player_money = save_dict.player_money
		player_name = save_dict.player_name
		last_ranked = save_dict.last_ranked
		upgrade_data.upgrades_bought = save_dict.upgrades_bought
		music_data.unlocked_songs = save_dict.unlocked_songs
		music_data.active_songs = save_dict.active_songs
		helper.log_message("found savegame with money: "+ str(save_dict.player_money))
		
#		print("loaded json, player_money: " + str(save_dict.player_money))
		
		save_file.close()

func save_game():
	var save_dict = {
		"player_money" : player_money,
		"player_name" : player_name,
		"last_ranked" : last_ranked,
		"upgrades_bought" : upgrade_data.upgrades_bought,
		"unlocked_songs" : music_data.unlocked_songs,
		"active_songs": music_data.active_songs
	}
	var save_file = File.new()
	var err = save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()
#	helper.log_message("saving game, error: %s" % err)
#	helper.log_message("saving game")

func save_config():
	helper.log_message("saving config")
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		config.set_value("audio", "master_volume", master_volume)		
		config.set_value("audio", "music_muted", music_muted)
		config.set_value("audio", "sound_muted", sound_muted)
		config.set_value("audio", "ambience_muted", ambience_muted)
		
#	helper.log_message("saving config with error code: %s" % err)
	config.save("user://settings.cfg")

func load_config():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == 0:
		master_volume = config.get_value("audio", "master_volume", master_volume)
		music_muted = config.get_value("audio", "music_muted", music_muted)
		sound_muted =  config.get_value("audio", "sound_muted", sound_muted)
		ambience_muted = config.get_value("audio", "ambience_muted", ambience_muted)
		
		print("last rank:" + str(last_ranked))
#	helper.log_message("loading config with error code: %s" % err)
	emit_signal("loaded")
	

func set_last_ranked(slug):
	last_ranked = slug
	save_game()

func set_player_money(slug):
	player_money = slug
	save_game()

func set_player_name(slug):
	player_name = slug
	save_game()
	
	