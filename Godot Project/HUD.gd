extends MarginContainer

#var DEBUG = 0.1
var DEBUG = 1

onready var player = get_node("/root/Game/Player")
onready var game  = get_node("/root/Game")

func _on_Upgrades_button_up():
	$MainBar.hide()
	$UgradeBar.show()
	$Sounds/Click.play()


func _on_BackButton_button_up():
	$MainBar.show()
	$UgradeBar.hide()
	$Sounds/Click.play()

func _on_Line_button_up():
	if game.money >= 150*DEBUG:
		$Sounds/Upgrade.play()
		player.upgrade_line()
		$UgradeBar/HBoxContainer/Line.disabled=true
		game.consume_money(150)

func _on_Spinner_button_up():
	if game.money >= 150*DEBUG:
		$Sounds/Upgrade.play()
		player.upgrade_spinner()
		$UgradeBar/HBoxContainer/Spinner.disabled=true
		game.consume_money(150)

func _on_Motor_button_up():
	if game.money >= 200*DEBUG:
		$Sounds/Upgrade.play()
		player.upgrade_motor()
		$UgradeBar/HBoxContainer/Motor.disabled=true
		game.consume_money(200)

func _on_Sinker_button_up():
	if game.money >= 200*DEBUG:
		$Sounds/Upgrade.play()
		player.upgrade_sinker()
		$UgradeBar/HBoxContainer/Sinker.disabled=true
		game.consume_money(200)

func _on_Storage_button_up():
	if game.money >= 300*DEBUG:
		$Sounds/Upgrade.play()
		player.upgrade_storage()
		$UgradeBar/HBoxContainer/Storage.disabled=true
		game.consume_money(300)


