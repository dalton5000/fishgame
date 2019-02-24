extends Node2D

var pop_scene = preload("res://hud/PopLabel.tscn")
signal money_collected

func pop(text, color):
	$kaching.play()
	var pop_label = pop_scene.instance()
	add_child(pop_label)
	pop_label.global_position = $stand.global_position+Vector2(0,-25)
	yield(get_tree(),"idle_frame")
	pop_label.pop_string(text, color)
	
func _ready():
	pass
#	pop("+100$",Color.red)

func _on_Area2D_body_entered(body):
	if body.is_in_group("fish_projectile"):
		if not body.collected:
			body.collected=true
			var value = -1
			var color = Color.red
			match body.type:
				0:
					color=Color.white
					value = 10
				1:
					color=Color.lightblue
					value = 25
				2:
					color=Color.pink
					value = 50
				3:
					color=Color.gold
					value = 100
					
			emit_signal("money_collected",value)
			pop("%s $"%str(value), color)