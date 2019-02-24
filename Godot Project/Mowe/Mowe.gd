extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base_y = 0.0
var offset_y =  0.0
var lifetime = 0.0

func _ready():
	base_y = position.y
	randomize()
	lifetime = randf() *60.0

func _physics_process(delta):
	lifetime += delta
	offset_y = sin(lifetime) * 40
	position.y = base_y + offset_y	


func _on_EatArea_body_entered(body):
	if body.is_in_group("fish_projectile"):
		body.get_eaten()
		$Quack.play()
		$Bite.play()