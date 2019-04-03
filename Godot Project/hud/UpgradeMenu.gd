extends PopupPanel

signal upgrade_bought
signal lowest_cost_calculated

onready var fishing_upgrade_list = $"VBoxContainer/TabContainer/Fishing Rod/Body/Title Container/UpgradeList/VBoxContainer"
onready var boat_upgrade_list = $"VBoxContainer/TabContainer/The Boat/Body/Title Container/UpgradeList/VBoxContainer"

var upgrade_entry_scene = preload("res://hud/upgrade_menu/UpgradeEntry.tscn")
var upgrade_entries = []

func clear_entries():
	for entry in upgrade_entries:
		entry.queue_free()

func load_entries():
	clear_entries()
	
	var lowest_upgrade_cost = 10000
	
	upgrade_entries = []
	for upgrade in upgrade_data.upgrades:
		var new_entry = upgrade_entry_scene.instance()
		
		var parent_node
		match upgrade_data.upgrades[upgrade]["category"]:
			"fishing":
				parent_node = fishing_upgrade_list
			"boat":
				parent_node = boat_upgrade_list
		
		new_entry.connect("upgrade_bought",self, "on_upgrade_buy_pressed")
		if upgrade_data.upgrades_bought[upgrade] < 3:
			var current_cost = upgrade_data.upgrades[upgrade]["cost"][upgrade_data.upgrades_bought[upgrade]]
			if current_cost < lowest_upgrade_cost: lowest_upgrade_cost = current_cost
		
		upgrade_entries.append(new_entry)
		parent_node.add_child(new_entry)
		
		new_entry.upgrade_name = upgrade
	print("lowest_cost_calculated" +  str(lowest_upgrade_cost))
	emit_signal("lowest_cost_calculated", lowest_upgrade_cost)

func on_upgrade_buy_pressed(upgrade_name):
	$Sounds/click.play()
	$Sounds/kaching.play()
	emit_signal("upgrade_bought", upgrade_name)

func _on_UpgradeMenu_about_to_show():
	load_entries()

func _on_CloseButton_pressed():
	$Sounds/click.play()
	hide()
	
func reload():
	load_entries()



func _on_TabContainer_tab_changed(tab):
	$Sounds/click.play()
