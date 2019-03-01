extends Node

var money = 0 setget set_money


#func _ready():
#	get_node("HighscoreLayer").hide()
	
func set_money(slug):
	money = slug
	$HUDLayer/HUD/MoneyPanel/Label.text = "%s$" % money

func _on_Stand_fish_collected(type):
	var data = fish_data
	var value = data.species[type]["value"]
	set_money(money+value)
