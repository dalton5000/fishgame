extends Node

var money = 0 setget set_money
var player_name = "some fisherbird" 

onready var log_list = $HUDLayer/HUD/LogPanel/ScrollContainer/RichTextLabel
onready var airplane_spawn = $Level/AirplaneSpawnPosition

onready var highscore_layer_scene = preload("res://utility_nodes/HighscoreLayer.tscn")
onready var airplane_scene = preload("res://level/Airplane.tscn")

var highscore_layer

func _physics_process(delta):
	$HUDLayer/FPSLabel.text = str(Engine.get_frames_per_second())

func log_message(message):
	$HUDLayer/HUD/LogPanel/ScrollContainer/RichTextLabel.append_bbcode("\n " + str(message))
	
func display_airplane_message(message):
	var new_airplane = airplane_scene.instance()
	$Level.add_child(new_airplane)
	new_airplane.message = message
	new_airplane.global_position = airplane_spawn.global_position

	
func _ready():
	helper.register_game(self)
	money = game_data.player_money
	$HUDLayer/HUD/MoneyPanel/VBoxContainer/ScoreLabel.text = helper.make_stringy_number(money)
	
func load_highscorelayer():
	
	highscore_layer = highscore_layer_scene.instance()
	add_child(highscore_layer)
	highscore_layer.connect("closed",self,"_on_highscorelayer_closed")
	highscore_layer.show()

func _on_highscorelayer_closed():
	highscore_layer.queue_free()
	
func set_money(slug):
	
	money = slug
	game_data.player_money = slug
	$HUDLayer/HUD/MoneyPanel/VBoxContainer/ScoreLabel.text = helper.make_stringy_number(game_data.player_money)


func _on_Stand_fish_collected(type):
	var data = fish_data
	var value = data.species[type]["value"]
	var message = "Sold %s for %s" % [data.species[type]["name"], helper.make_stringy_number(data.species[type]["value"])]
	log_message(message)
	set_money(money+value)
	get_tree().call_group("combobar","_on_fish_collected", type)
	
func show_highscore_layer():
	$HighscoreLayer.set_player_name(player_name)
	$HighscoreLayer.set_player_money(money)
	

	
		
func _on_HighscoreLayer_player_name_entered(new_name):
	game_data.player_name = new_name


func _on_Leaderboard_pressed():
	$Sounds/Click.play()
	load_highscorelayer()

func _on_Settings_pressed():
	$Sounds/Click.play()
	$HUDLayer/SettingsMenu.popup()



func _on_ComboBar_combo_lost():
	pass # Replace with function body.


func _on_ComboBar_combo_won(reward):
	$Level/Stand.money_collected(reward)
	set_money(money+reward)

func _on_ComboBar_sale_started(species, tier):
	var new_airplane = airplane_scene.instance()
	$Level.add_child(new_airplane)
	new_airplane.show_sale_message(species,tier)
	new_airplane.global_position = airplane_spawn.global_position
	



func _on_FreeCamButton_toggled(button_pressed):
	if button_pressed:
		get_tree().call_group("player_cam", "clear_current")
		get_tree().call_group("free_cam", "make_current")
	else:
		get_tree().call_group("free_cam", "clear_current")
		get_tree().call_group("player_cam", "make_current")	
		
#yield(get_tree(),"idle_frame")

func buy_upgrade(upgrade_name):
	var current_tier = upgrade_data.upgrades_bought[upgrade_name]
	var cost = upgrade_data.upgrades[upgrade_name]["cost"][current_tier]
	set_money(money-cost)
	upgrade_data.upgrades_bought[upgrade_name] += 1
	get_tree().call_group("menu","reload")
	game_data.save_game()
	
func _on_Upgrades_pressed():
	$Sounds/Click.play()
	$HUDLayer/HUD/UpgradeMenu.popup()

func _on_UpgradeMenu_upgrade_bought(upgrade_name):
	var current_tier = upgrade_data.upgrades_bought[upgrade_name]
	if current_tier < 3:
		if upgrade_data.upgrades[upgrade_name]["cost"][current_tier] < game_data.player_money:
			buy_upgrade(upgrade_name)


func _on_MoneyButton_pressed():
	set_money(money+1000)


func _on_JukeboxButton_pressed():
	$Sounds/Click.play()
	$HUDLayer/HUD/JukeboxPanel._on_Show_pressed()

func _on_SettingsMenu_reset_game():	
	game_data.reset_game()
	set_money(game_data.player_money)