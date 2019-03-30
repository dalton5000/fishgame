extends Area2D
class_name Fish

signal eaten

enum FISH_STATES { IDLE, LURED, HOOKED, COLLECTED }
var state = FISH_STATES.IDLE

var type_id = 0

func _ready():
	yield(get_tree(),"idle_frame")
	randomize()
	$Body/Sprite.frame = type_id * 5

	
	$Timers/Velocity.wait_time = randf()*4 + randf()*4 + 1.0
	$Timers/Direction.wait_time = randf()*4 + randf()*4 + 1.0
	$Timers/Direction.start()
	$Timers/Velocity.start()
	$Sounds/Bite.pitch_scale = 0.85 + randf() * 0.3


func _on_BiteArea_body_entered(body):
	if body.is_in_group("lure"):
#		helper.log_message("fish on hook: %s, maximum: %s" % [body.hooked_fish.size(), upgrade_data.get_current_value("hook")])
		if body.hooked_fish.size() < upgrade_data.get_current_value("hook"):
			get_hooked(body)


var dir = 1
var velocity = Vector2()
export var h_speed = 50.0
export var v_speed = 20.0
var hook : Node
var position_on_hook = 0
#
func _physics_process(delta):

	match state:
		FISH_STATES.IDLE:
			velocity = lerp(velocity,Vector2.ZERO,0.01)
			position += velocity * delta
		FISH_STATES.HOOKED:
			look_at(hook.global_position+Vector2(0,6))
			global_position = hook.global_position+Vector2(0,6)

	

func switch_state(new_state):
	if new_state != state:
		state = new_state
		match new_state:
			FISH_STATES.IDLE:
				pass
			FISH_STATES.COLLECTED:
				queue_free()

func on_lure_disconnected():
	hook = null
	rotation_degrees= 0.0
	switch_state(FISH_STATES.IDLE)
	
func get_hooked(lure):
	$Body.scale = Vector2(1,1)
	hook = lure
	switch_state(FISH_STATES.HOOKED)
	lure.connect("disconnected",self,"on_lure_disconnected")
	lure.connect("collected",self,"on_lure_collected")
	$Sounds/Bite.play()
	lure.hook_fish(type_id)
	
func on_lure_collected():
	get_collected()
#	pass
	
func get_collected():
#	queue_free()
	switch_state(FISH_STATES.COLLECTED)

func get_eaten():
#	$Sprite.frame=6
	$Body/Sprite.frame = 4
	emit_signal("eaten",self)
	$Tween.interpolate_property(self,"modulate",Color.white,Color(1, 1, 1, 0),0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	if state == FISH_STATES.HOOKED:
		hook.unhook_fish(type_id)
	yield($Tween,"tween_completed")
	queue_free()

func _on_Direction_timeout():
	randomize()
	if state == FISH_STATES.IDLE:
		change_direction()
		$Timers/Direction.wait_time = randi()%5+1

func _on_Velocity_timeout():
	if state == FISH_STATES.IDLE:
		swim_impulse()
		$Timers/Velocity.wait_time = (randf()*6+2.0)
		
func swim_impulse():
	velocity = Vector2(dir*h_speed,0.0)
	velocity.y =  randf()*v_speed-v_speed/2
	
	
func hit_top_border():
	if state == FISH_STATES.IDLE:
		dir = 1 if randi()%2 == 1 else -1
		$Timers/Direction.wait_time = randi()%5+1
		$Timers/Velocity.wait_time = (randf()*6+2.0)
		if dir == 1:
			$Body.scale = Vector2(1,1)
		else:
			$Body.scale = Vector2(-1,1)
		velocity = Vector2(dir*h_speed,0.0)
		velocity.y =  3
		
func hit_bottom_border():
	if state == FISH_STATES.IDLE:
		dir = 1 if randi()%2 == 1 else -1
		$Timers/Direction.wait_time = randi()%5+1
		$Timers/Velocity.wait_time = (randf()*6+2.0)
		if dir == 1:
			$Body.scale = Vector2(1,1)
		else:
			$Body.scale = Vector2(-1,1)
		velocity = Vector2(dir*h_speed,0.0)
		velocity.y =  -3
		
func hit_left_border():
	if state == FISH_STATES.IDLE:
		change_direction()
		velocity = Vector2(dir*h_speed,0.0)

func change_direction():
	
	if dir == -1:
		$Body/Sprite.frame = type_id * 5 + 2
	else:
		$Body/Sprite.frame = type_id * 5
		
	yield(get_tree().create_timer(0.15),"timeout")
	$Body/Sprite.frame = type_id * 5+1
	
	dir *= -1
	yield(get_tree().create_timer(0.15),"timeout")
	
	if dir == -1:
		$Body/Sprite.frame = type_id * 5 + 2
	else:
		$Body/Sprite.frame = type_id * 5
	
	
	
func hit_right_border():
	if state == FISH_STATES.IDLE:
		change_direction()
		velocity = Vector2(dir*h_speed,0.0)