extends Node2D

enum ROD_STATES { IDLE, THROWING, FLYING, SINKING, PULLING }
var rod_state = ROD_STATES.IDLE

var velocity = 0.0
var base_velocity = 70.0
var max_velocity = 70.0

var base_acc = 0.5
var acc = 0.5
var base_deacc = 0.7
var deacc = 0.7

var throwing_time = 0.0
var max_throwing_time = 1.0
var max_throwing_power = 80
var max_fish_throwing_power = 160
var max_throwing_torque = 80

var motor_loudness_min = 0.1
var motor_loudness_max = 1.0

var lure_scene = preload("res://player/Lure.tscn")
var projectile_scene = preload("res://player/FishProjectile.tscn")

var border_hit = 0

var lure : Node 
var lure_distance := 0.0
var max_lure_distance := 250.0

var rod_pulling_speed = 1.0
var base_spinning_speed = 50.0

onready var cam = $Camera2D

onready var rod = $Boat/Angler/Rod
onready var rod_tween = $Boat/Angler/Rod/Tween
onready var motor_sound = $Sounds/Motor
onready var rod_end = $Boat/Angler/Rod/EndPosition
onready var collision_sound = $Sounds/Collision

var left_mouse_clicked = false



func _ready():
	$Boat/FlagAnimation.play("wave")
	set_process_input(true)
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_mouse_clicked = true
			
func _physics_process(delta):
	max_velocity = base_velocity * upgrade_data.get_current_value("motor")
	acc = base_acc * upgrade_data.get_current_value("motor")
	deacc = base_deacc * upgrade_data.get_current_value("motor")
	
	_ship_movement(delta)
	_handle_rope(delta)
	update()
	match rod_state:
		ROD_STATES.IDLE:
			if left_mouse_clicked:
				start_throwing()
			if Input.is_action_just_pressed("throw_fish"):
				throw_fish()
		ROD_STATES.THROWING:
			throwing_time+=delta
			if Input.is_action_just_released("throw_lure"):
				throw_lure()
		ROD_STATES.FLYING:
			pass
		ROD_STATES.SINKING:
			if left_mouse_clicked:
				switch_rod_state(ROD_STATES.PULLING)
		ROD_STATES.PULLING:
			if Input.is_action_just_released("throw_lure"):
				switch_rod_state(ROD_STATES.SINKING)
			var lure_impulse = (rod_end.global_position-lure.global_position).normalized() * base_spinning_speed * upgrade_data.get_current_value("spinner")
#			$Sounds/Reel.play()
#			lure.apply_impulse(Vector2.ZERO,lure_impulse * rod_pulling_speed)
			lure.linear_velocity = lure_impulse * rod_pulling_speed
			
	#reset flag from unhandled input
	left_mouse_clicked = false
func _handle_rope(delta):
	if not rod_state in [ROD_STATES.IDLE, ROD_STATES.THROWING]:
		lure_distance = (lure.global_position - global_position).length()
		if lure_distance > max_lure_distance*upgrade_data.get_current_value("line"):			
			disconnect_lure()
		
func switch_rod_state(new_state):
	if new_state != rod_state:
		rod_state = new_state
		match new_state:
			ROD_STATES.IDLE:
				cam.target = self
				$Sounds/Pull.stop()	
				$Sounds/Spin.stop()
			ROD_STATES.FLYING:
				cam.target = lure
				$Sounds/Spin.play()
			ROD_STATES.SINKING:
				$Sounds/Pull.stop()				
				$Sounds/Spin.play()
			ROD_STATES.PULLING:
				$Sounds/Spin.stop()
				$Sounds/Pull.play()
				
func disconnect_lure():
	if lure:
		lure.disconnect_rod()
	switch_rod_state(ROD_STATES.IDLE)

func start_throwing():
	throwing_time = 0.0
	switch_rod_state(ROD_STATES.THROWING)
	$Boat/Angler/Rod/RodAnimation.play("wind_up")
	
	
func _ship_movement(delta):
	tune_motor_sound()
	
	var dir = 0
	if Input.is_action_pressed("move_left"):
		dir = -1
	if Input.is_action_pressed("move_right"):
		dir = 1
		
	if border_hit == 0:
		pass
	else:
		velocity = -border_hit
		
	if velocity > 0:
		$Boat/Flag.flip_h = false
	else:
		$Boat/Flag.flip_h = true
	
#	if dir == 1:
		
	if dir == 0:
		if abs(velocity) >1.0:
			if velocity > 0:
				velocity -= deacc
			else:
				velocity -= -deacc
	else:
		velocity += acc * dir
		if abs(velocity) > max_velocity:
			velocity = max_velocity * dir
	
	
	position.x += velocity*delta
	
func tune_motor_sound():
	var db = abs(velocity)/max_velocity
	db = linear2db(clamp(db,motor_loudness_min,motor_loudness_max))
	motor_sound.volume_db = db
	if abs(velocity)/max_velocity > 0.5:
		$Boat/MotorParticles.emitting = true
	else:
		$Boat/MotorParticles.emitting = false
#	var particle_amount = int( (abs(velocity)/max_velocity) * 8)
#	$Boat/MotorParticles.get_child(0).amount = particle_amount
	
func throw_fish():
#	if fish_on_board.size() > 0:
#		yield(get_tree(),"idle_frame")
#		$Sounds/Throw.play()
#	var current_fish = fish_on_board.back()
	if $Boat/FishLoad.has_fish():
		var next_type = $Boat/FishLoad.remove_fish()
		
		var fish = projectile_scene.instance()
	#	fish.get_node("Sprite").frame = current_fish
		add_child(fish)
		fish.global_position = $Boat/FishLoad/Position2D3.global_position - Vector2(6,0)
		var dir = (get_global_mouse_position()-global_position).normalized()
		fish.type = next_type
		fish.add_torque(max_throwing_torque)	
		fish.apply_impulse(Vector2.ZERO,dir*max_fish_throwing_power)
		$Sounds/Throw.play()
#		fish.value = current_fish
#		fish.type = current_fish
		
#		$FishLoad.get_child(fish_on_board.size()-1).hide()
		
#		fish_on_board.pop_back()
		
func throw_lure():
	$Sounds/Throw.play()
	lure = lure_scene.instance()
	get_parent().add_child(lure)
	lure.global_position = rod_end.global_position
	
	var dir = (get_global_mouse_position()-rod_end.global_position).normalized()
	dir.y = clamp(dir.y,-1.0,0.1)
	var power = (throwing_time / max_throwing_time ) * max_throwing_power
	
	
	lure.apply_impulse(Vector2.ZERO,dir * power * upgrade_data.get_current_value("rod"))
	
	lure.connect("entered_water",self,"_lure_entered_water")
	
	$Boat/Angler/Rod/RodAnimation.stop()
	var rod_rot = rod.rotation_degrees
	rod_tween.interpolate_property(rod,"rotation_degrees", rod_rot,0.0,0.2,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
	rod_tween.start()
	
	switch_rod_state(ROD_STATES.FLYING)
	
func _on_CollectionArea_area_entered(area):
#	if area.is_in_group("fish"):
#		area.get_collected()
	
	if area.is_in_group("record"):
		area.get_collected()	

func _on_CollectionArea_body_entered(body):
	if body.is_in_group("lure"):
		if not rod_state == ROD_STATES.FLYING:
			for fish_type in lure.hooked_fish:
				$Boat/FishLoad.store_fish(fish_type)
			lure.get_collected()
			disconnect_lure()
			
func _on_RodAnimation_animation_finished(anim_name):
	if anim_name == "wind_up":
		if rod_state == ROD_STATES.THROWING:
			throw_lure()

func _draw():
	if not rod_state in [ROD_STATES.IDLE, ROD_STATES.THROWING]:
		var col = Color.green
		col.r = range_lerp(lure_distance,0.0,max_lure_distance,0.0,1.0)
		col.g = range_lerp(lure_distance,0.0,max_lure_distance,1.0,0.0)
#		draw_line(rod_end.global_position-global_position,lure.global_position-global_position,Color.brown,1.5,true)
		draw_line(rod_end.global_position-global_position,lure.global_position-global_position,col,1.5,true)
		
func _lure_entered_water():
	if rod_state == ROD_STATES.FLYING:
		switch_rod_state(ROD_STATES.SINKING)

func _on_Left_pressed():
	print("left")
	pass # Replace with function body.


func _on_Right_pressed():
	pass # Replace with function body.


func _on_Left_released():
	pass # Replace with function body.


func _on_Right_released():
	pass # Replace with function body.


func _on_LeftCollider_area_entered(area):
	border_hit = -1
	collision_sound.play()


func _on_RightCollider_area_entered(area):
	border_hit = 1
	collision_sound.play()


func _on_LeftCollider_area_exited(area):
	border_hit = 0


func _on_RightCollider_area_exited(area):
	border_hit = 0
