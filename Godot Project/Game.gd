extends Node

var money = 0


func _on_Stand_money_collected(amount):
	money += amount
	var m = str(money)
#	$HUD-Layer/HUD/MoneyLabel.text = m
	$"HUD-Layer/HUD/MoneyLabel".text=m + "$"

func _on_RETIRE_pressed():
	if money >= 2000:
		win_game()
		
func win_game():
	$"HUD-Layer/WinPanel/AnimationPlayer".play("win")

func consume_money(amount):
	money -= amount
	var m = str(money)
#	$HUD-Layer/HUD/MoneyLabel.text = m
	$"HUD-Layer/HUD/MoneyLabel".text=m + "$"