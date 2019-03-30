extends Node2D

var message = "3 Greens for 100$" setget set_message

var speed = -100
var lifetime = 0.0

var text_colors_for_tier = [
	Color.lightgray.to_html(false),
	Color(0.375, 0.677734, 1).to_html(false),
	Color(0.848511, 0.429688, 1).to_html(false),
	Color(1, 0.839722, 0.210938).to_html(false)
	]

var adjectives_for_tiers = [
	"There's a ",
	"Nice",
	"Great",
	"EPIC"
	]

var message_template = "[color=#%s] %s Bonus[/color] for this Combo:"

onready var fish_icons = [$PanelContainer/HBoxContainer/FishIcon, $PanelContainer/HBoxContainer/FishIcon2, $PanelContainer/HBoxContainer/FishIcon3]
onready var label = $PanelContainer/HBoxContainer/Label

func set_message(slug):
	message = slug
	label.text = message

func _physics_process(delta):
	lifetime += delta
	position.x += speed *delta

	position.y += sin(lifetime+1.5)*0.2

func _on_VisibilityNotifier2D_viewport_entered(viewport):
	$Wroom.play()

func show_sale_message(species, tier):
	label.text = message

	for i in fish_icons.size():
		fish_icons[i-1].texture.region.position.x = float(species * 10)
	var color = text_colors_for_tier[tier]
	print(color)
	var adjective = adjectives_for_tiers[tier]
	message = message_template % [color, adjective]
	$PanelContainer/HBoxContainer/RichTextLabel.bbcode_text = message
#	$PanelContainer.self_modulate = color
#	label.self_modulate = color