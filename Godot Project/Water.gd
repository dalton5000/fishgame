extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Water_body_entered(body):
	if body.is_in_group("lure"):
		body.in_water = true
	if body.is_in_group("fish_projectile"):
		body.hit_water()

func _on_Water_body_exited(body):
	pass # Replace with function body.
	if body.is_in_group("lure"):
		body.in_water= false