extends Area2D

onready var parent = get_parent()

var speed = 20
var direction = Vector2(1,0)
var speed_offset = 0.0
var lifetime = 0.0

func _ready():
	
	randomize()
	direction.y = randf() * 0.5

	if randi()%2==1:
		direction.x = -direction.x
		
func _physics_process(delta):
	lifetime += delta
	speed_offset = sin(lifetime) * 7.0
	parent.position += direction * (speed+speed_offset) * delta
	
func _on_Timer_timeout():
	randomize()
	var new_dir = Vector2(1,0)
	new_dir.y = randf() * 0.5
	
	if randi()%2==1:
		new_dir.x = -new_dir.x
		 
	$Tween.interpolate_property(self,"direction",direction,new_dir,3.0,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()

func hit_top_border():
	direction.y = 0.3