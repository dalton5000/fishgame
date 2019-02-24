extends Node2D

enum STATES { HOLD, SINK, PULL }
var state = STATES.HOLD setget set_state

var MAX_SPEED := 100.0
const ACC := 3.0
const DEACC := 7.0

var velocity := Vector2(0,0)
var direction := -1

var fish_on_board = []
var max_fish_on_board = 7
var max_fish_at_lure = 3
var max_throwing_power = 200
var max_throwing_torque = 8000
var spinning_speed = 1
var winding = false
var fish_at_rod = false

var lure
var has_lure = false
var lure_position := Vector2()
var lure_distance := 0.0
var max_lure_distance := 250.0
#onready var lure = $lure

var fish_scene = preload("res://player/FishProjectile.tscn")
var lure_scene = preload("res://player/lure.tscn")

onready var camera = $Camera
onready var rod_end = $rod_end

#onready var barrier_left = get_node("../Level/Barriers/Left").global_position
#onready var barrier_right = get_node("../Level/Barriers/Right").global_position
func _ready():
	set_process_input(true)
	
func _physics_process(delta):
	
	
	
	boat_movement(delta)
	$Label.text = str(state)
	match state:
		STATES.HOLD:
			camera.target_pos = position
			pass
		STATES.PULL:
			camera.target_pos = lure.position
			var lure_impulse = (rod_end.global_position-lure.global_position).normalized() * 20.0
			$Sounds/Reel.play()
			lure.apply_impulse(Vector2.ZERO,lure_impulse * spinning_speed)
			
			if not Input.is_action_pressed("throw_lure"):
				set_state(STATES.SINK)
		STATES.SINK:
			camera.target_pos = lure.position
			if lure.in_water:
				var lure_impulse = (rod_end.global_position-lure.global_position).normalized() * 20.0
				lure_impulse.y=0
				lure.apply_impulse(Vector2.ZERO,lure_impulse/2)
			
			if Input.is_action_just_pressed("throw_lure"):
				set_state(STATES.PULL)
	if has_lure:
		lure_position = lure.global_position
		lure_distance = (lure.position - global_position).length()
		if lure_distance > max_lure_distance:			
			disconnect_lure()
			lure_distance = 0.0
			$Sounds/Tear.play()
		$DistanceLabel.text=  ( str( lure_distance))
#	global_position.x = clamp(global_position.x, barrier_left.x,barrier_right.x)
	global_position.x = clamp(global_position.x, -590,85)
	update()
	var vol = clamp((abs(velocity.x)/50),0.0,2.0)
	
	$Sounds/Motor.volume_db = linear2db(vol)
	
func disconnect_lure():
	if has_lure:
		lure.disconnect_rod()

func boat_movement(delta):
	if Input.is_action_pressed("ui_right"):
		direction=1
	elif Input.is_action_pressed("ui_left"):
		direction=-1
	else:
		direction=0
	
	match direction:
		0:
			velocity.x = lerp(velocity.x,0.0,0.03)
#			if abs(velocity.x) > 0:
#				velocity.x -= DEACC
		1:
			velocity.x = lerp(velocity.x,MAX_SPEED,0.03)
#			lerp(velocity.x,0.0,0.03)
#			if velocity.x <0:
		-1:
			velocity.x = lerp(velocity.x,-MAX_SPEED,0.03)
#			if velocity.x <0:
	position.x += velocity.x*delta
	
func throw_lure():	
	disconnect_lure()
	
	lure = lure_scene.instance()
	$Sounds/Throw.play()
	get_parent().add_child(lure)
	lure.global_position = rod_end.global_position
	yield(get_tree(), "idle_frame")
	var dir = (get_global_mouse_position()-rod_end.global_position).normalized()	
	lure.apply_impulse(Vector2.ZERO,dir*max_throwing_power*1.5)
	lure.max_fish = max_fish_at_lure
	lure.connect("hooked",self,"_on_lure_hooked")
	lure.connect("disconnected",self,"_on_lure_disconnected")
	has_lure=true

func set_state(new_state):
	if new_state != state:
		var last_state = state
		match new_state:
			STATES.HOLD, STATES.SINK:
				$Sounds/Reel.stop()
			STATES.PULL:
				$Sounds/Reel.play()
			STATES.SINK:
				pass
				
		
		state = new_state
func _unhandled_input(event):
	match state:
		STATES.HOLD:
			if event is InputEventMouseButton and event.pressed:
				if event.button_index == BUTTON_LEFT:
					throw_lure()
					set_state(STATES.SINK)
				elif event.button_index == BUTTON_RIGHT:
					throw_fish()
					
#		STATES.SINK:
#			if event is InputEventMouseButton and event.pressed:
#				if event.button_index == BUTTON_LEFT:
#					set_state(STATES.PULL)
#	if not fish_at_rod:
#		if event is InputEventMouseButton and event.pressed:
#			if event.button_index == BUTTON_LEFT:
#				throw_lure()
#			if event.button_index == BUTTON_RIGHT:
#				throw_fish()

func _on_lure_disconnected():
	set_state(STATES.HOLD)
	has_lure = false

func _on_lure_hooked():
	fish_at_rod = true
	
func throw_fish():
	if fish_on_board.size() > 0:
		yield(get_tree(),"idle_frame")
		$Sounds/Throw.play()
		var current_fish = fish_on_board.back()
		
		var fish = fish_scene.instance()
		fish.get_node("Sprite").frame = current_fish
#		fish.value = current_fish
		fish.type = current_fish
		add_child(fish)
		var dir = (get_global_mouse_position()-global_position).normalized()
		fish.add_torque(max_throwing_torque)	
		fish.apply_impulse(Vector2.ZERO,dir*max_throwing_power)
		
		$FishLoad.get_child(fish_on_board.size()-1).hide()
		
		fish_on_board.pop_back()
		
		
func _draw():
	if has_lure:
		var col = Color.green
		col.r = range_lerp(lure_distance,0.0,max_lure_distance,0.0,1.0)
		col.g = range_lerp(lure_distance,0.0,max_lure_distance,1.0,0.0)
		draw_line(rod_end.global_position-global_position,lure_position-global_position,col,1.5,true)
	
	
func collect_fish(fish):
	if fish_on_board.size() < max_fish_on_board:
		$Sounds/Collect.play()
		fish_on_board.append(fish.type)
		$FishLoad.get_child(fish_on_board.size()-1).frame = fish.type
		$FishLoad.get_child(fish_on_board.size()-1).show()
		yield(get_tree().create_timer(0.1),"timeout")
		fish_at_rod=false
	
func _on_CollectArea_body_entered(body):
	if body.is_in_group("fish"):		
		collect_fish(body)
		body.get_collected()
	if body.is_in_group("lure"):
		if body.lifetime >= 0.5:
			set_state(STATES.HOLD)
			disconnect_lure()

func upgrade_storage():
	max_fish_on_board = 10

func upgrade_line():
	max_lure_distance = max_lure_distance*2

func upgrade_motor():
	MAX_SPEED = 200.0

func upgrade_sinker():
	max_fish_at_lure = 5

func upgrade_spinner():
	spinning_speed *= 2