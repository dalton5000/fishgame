
extends Area2D

export var speed = 80.0
var dir
var velocity = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_Timer_timeout()

func _physics_process(delta):
	position.x+=(velocity*delta)
	velocity = lerp(velocity,0,0.01)
	global_position.x = clamp(global_position.x, -620,130)


func _on_EatArea_body_entered(body):
	if body.is_in_group("fish"):
		body.get_eaten()
		$Bite.play()

func _on_Timer_timeout():
	randomize()
	
	dir = 1 if randi()%2 == 1 else -1
	if dir == 1:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
	velocity = dir * speed
	$Timer.wait_time = 1.5 + randf()