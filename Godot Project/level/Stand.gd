extends Node2D
signal fish_collected

var pop_scene = preload("res://hud/PopLabel.tscn")

func _on_Area2D_body_entered(body):
	if body.is_in_group("fish_projectile"):
		body.get_collected()
		emit_signal("fish_collected",body.type)
		$Sounds/Kaching.play()
		var value = fish_data.species[body.type].value 
		var text = "+" + str(value) + "$"
		pop(text,Color.white)

func pop(text, color):
	var pop_label = pop_scene.instance()
	add_child(pop_label)
	pop_label.global_position = $PopLabelPosition.global_position+Vector2(0,-25)
	yield(get_tree(),"idle_frame")
	pop_label.pop_string(text, color)