extends KinematicBody2D

signal eaten

var dir = 1
var velocity = Vector2()
export var h_speed = 50.0
export var v_speed = 50.0
var hooked = false
var hook : Node
var eaten=false



export var value = 10
export var type = -1

func _ready():
	randomize()
	if type == -1:
		var dice = randi() % 100
		if dice > 95:
			type = 3
		elif dice > 90:
			type = 2
		elif dice > 70:
			type = 1
		else:
			type = 0
	
	match type:
		0:
			value = 10
		1:
			value = 20
		2:
			value = 50
		3:
			value = 100
			
	if is_in_group("fish_top"):
		if type == 2: add_to_group("purple_top")
		
	else:
		if type == 1: add_to_group("blue_bottom")
		elif type == 2: add_to_group("purple_bottom")
		elif type == 3: add_to_group("golden")
	
	$Sprite.frame = type
	
	_on_DirectionTimer_timeout()
	_on_SwimTimer_timeout()
	$Bite.pitch_scale = 0.85 + randf() * 0.3
	
func _physics_process(delta):
	if not eaten:
		if hooked:
			if hook:
				global_position = hook.global_position
				look_at(hook.global_position-Vector2(0,-1))
		else:
			move_and_slide(velocity)
			velocity = lerp(velocity,Vector2.ZERO,0.01)
	
	if not hooked:
		position.y = clamp(position.y, 160,550)
		
	global_position.x = clamp(global_position.x, -620,130)
	
func _on_DirectionTimer_timeout():
	dir = 1 if randi()%2 == 1 else -1
	$DirectionTimer.wait_time = randi()%5+1
	if dir == 1:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func _on_SwimTimer_timeout():
	velocity = Vector2(dir*h_speed,0.0)
	velocity.y =  randf()*v_speed-v_speed/2
	$SwimTimer.wait_time = (randf()*6+2.0)
	
func on_lure_disconnected():
	hooked = false
	hook = null
	rotation_degrees= 0.0
	
func get_hooked(lure):
	lure.connect("disconnected",self,"on_lure_disconnected")
	hook = lure
	hooked = true
	$Bite.play()
	
func get_collected():
	queue_free()

func get_eaten():
	eaten=true
	$Sprite.frame=6
	emit_signal("eaten",self)
	$Tween.interpolate_property(self,"modulate",Color.white,Color(1, 1, 1, 0),0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	queue_free()