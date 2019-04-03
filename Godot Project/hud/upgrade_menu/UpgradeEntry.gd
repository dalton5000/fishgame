extends PanelContainer

signal upgrade_bought

var upgrade_name setget set_upgrade_name

var bb_code_color_grey = "#" + Color(0.882813, 0.882813, 0.882813).to_html(false)
var bb_code_color_blue = "#" + Color(0.507813, 0.700073, 1).to_html(false)
var bb_code_color_purple = "#" + Color(0.984619, 0.507813, 1).to_html(false)
var bb_code_color_gold = "#" + Color(1, 0.944458, 0.492188).to_html(false)

var particles_upgrade_blue = preload("res://graphics/particles/UpgradeParticlesBlue.tscn")
var particles_upgrade_purple = preload("res://graphics/particles/UpgradeParticlesPurple.tscn")
var particles_upgrade_gold = preload("res://graphics/particles/UpgradeParticlesGold.tscn")
#onready var particles_upgrade_blue = $Body/UpgradeColumn/TierIcon/Sprite/ParticlesBlue

var value_text_template = "[color=%s]%s[/color] / [color=%s]%s[/color] / [color=%s]%s[/color] / [color=%s]%s[/color] %s"


var upgrade_button_text_template = "Upgrade (%s$)"
var upgrade_button_text_finished = "Fully upgraded!"

#func _ready():
#	particles_upgrade_blue.emitting = false
#	particles_upgrade_blue.one_shot = true

func set_upgrade_name(slug):
	upgrade_name = slug
	reload()

func get_underlined_value_as_string(tier):
	var val = ""
	if upgrade_data.upgrades_bought[upgrade_name] == tier:
		val = "[u]" + str(upgrade_data.upgrades[upgrade_name]["displayed_values"][tier]) + "[/u]"
	else:
		val = str(upgrade_data.upgrades[upgrade_name]["displayed_values"][tier])
	return(val)
		
func reload():
	var upgrade = upgrade_data.upgrades[upgrade_name]
	$Body/UpgradeColumn/Name.text = upgrade["displayed_name"]
	$Body/TextColumn/Description.text = upgrade["description"]
	$Body/TextColumn/Flavor.text = upgrade["flavor_text"]
	var value_text = value_text_template % [
					bb_code_color_grey,
					get_underlined_value_as_string(0),
					bb_code_color_blue,
					get_underlined_value_as_string(1),
					bb_code_color_purple,
					get_underlined_value_as_string(2),
					bb_code_color_gold,
					get_underlined_value_as_string(3),
					upgrade["value_name"]
					]
	$Body/TextColumn/Values.bbcode_text = value_text
	
	var current_tier = upgrade_data.upgrades_bought[upgrade_name]
	
	$Body/UpgradeColumn/TierIcon/Sprite.frame = current_tier
	
#	print("button has current tier: %s" % current_tier)
	if current_tier == 3:
			$Body/UpgradeColumn/UpgradeButton.text = upgrade_button_text_finished
			$Body/UpgradeColumn/UpgradeButton.disabled = true
	
	else:
			var cost = float(upgrade["cost"][current_tier])
			$Body/UpgradeColumn/UpgradeButton.text = upgrade_button_text_template % cost
#			print("button found cost and money: %s %s" % [cost,game_data.player_money])
			$Body/UpgradeColumn/UpgradeButton.disabled = ( cost > game_data.player_money )
	
func _on_UpgradeButton_pressed():
	match upgrade_data.upgrades_bought[upgrade_name]:
		0:
			show_upgrade_particle(
								particles_upgrade_blue,
								$Body/UpgradeColumn/TierIcon/Sprite/Blue.global_position)
		1:
			show_upgrade_particle(
								particles_upgrade_purple,
								$Body/UpgradeColumn/TierIcon/Sprite/Purple.global_position)
		2:
			show_upgrade_particle(
								particles_upgrade_gold,
								$Body/UpgradeColumn/TierIcon/Sprite/Gold.global_position)
#	yield(get_tree().create_timer(1.0),"timeout")
	emit_signal("upgrade_bought", upgrade_name)
		
func show_upgrade_particle(particle_node, pos):
	var new_parts = particle_node.instance()
	get_node("/root/Game/HUDLayer/HUD/UpgradeMenu").add_child(new_parts)
#	get_node("Body/UpgradeColumn/TierIcon/Sprite").add_child(new_parts)
	new_parts.global_position = pos
#	new_parts.restart()
	new_parts.one_shot = true