extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var r_id = randi()%get_child_count()
	get_child(r_id).play()

func _on_Song1_finished():
	$Song2.play()

func _on_Song2_finished():
	$Song1.play()