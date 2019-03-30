extends Node2D

enum MOVEMENT_MODES { VERTICAL, HORIZONTAL }
var current_mode = -1

export var range_v = 40.0
export var range_h = 60.0

var counter_x = 0.0
var counter_y = 0.0

onready var base_position = position
onready var offset = Vector2(0,0)
var last_offset 


func _ready():
	switch_mode(MOVEMENT_MODES.HORIZONTAL)
	counter_x=randf()*60.0
	counter_y=randf()*60.0
	offset.x = sin(counter_x) * range_h
	offset.y = sin(counter_y) * range_v
	$Timer.wait_time = rand_range(3.5,7.0)
#	$Timer.wait_time.start()

func _physics_process(delta):
	last_offset = offset
	match current_mode:
		MOVEMENT_MODES.HORIZONTAL:
			counter_x += delta
			offset.x = sin(counter_x) * range_h
			$AnimatedSprite.flip_h = offset.x >= last_offset.x
		MOVEMENT_MODES.VERTICAL:
			counter_y += delta
			offset.y = sin(counter_y) * range_v
	position = base_position + offset


func switch_mode(new_mode):
	if new_mode != current_mode:
		current_mode = new_mode
		match new_mode:
			MOVEMENT_MODES.HORIZONTAL:
				$AnimatedSprite.play("fly")
			MOVEMENT_MODES.VERTICAL:
				$AnimatedSprite.play("stand")


func _on_Timer_timeout():
	if randf() >= 0.35:
		if current_mode == MOVEMENT_MODES.HORIZONTAL:
			switch_mode(MOVEMENT_MODES.VERTICAL)
		else:
			switch_mode(MOVEMENT_MODES.HORIZONTAL)
	
	$Timer.wait_time = rand_range(3.5,7.0)

func _on_Area2D_body_entered(body):
	if body.is_in_group("fish_projectile"):
		body.get_eaten()
		$Sounds/Bite.play()
		yield(get_tree().create_timer(rand_range(0.2,0.4)),"timeout")
		$Sounds/Squak.play()