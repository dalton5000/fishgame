extends Area2D

export var speed = 60
var dir = 1
var velocity = 0.0
var sprite_direction = 1

var travel_counter = 0
export var max_travelling = 3


func _ready():
	$WaitTimer.wait_time = randf()
	$WaitTimer.start()

func _physics_process(delta):
	position.x+=(velocity*delta)
	velocity = lerp(velocity,0,0.01)
	if velocity <= 12:
		if $WaitTimer.is_stopped():
			$WaitTimer.wait_time = rand_range(0.75,1.75)
			$WaitTimer.start()


func change_direction():
	var new_dir = get_new_direction()
	if new_dir != dir:
		if dir == 1:
			$DirectionAnim.play("to_left")
		else:
			$DirectionAnim.play_backwards("to_left")
			
		yield($DirectionAnim,"animation_finished")
#		yield(get_tree().create_timer(0.2),"timeout")
	dir = new_dir
	dash()

func dash():
	
	travel_counter += dir
	velocity = dir * speed * rand_range(0.75,1.25)

func _on_Piranha_area_entered(area):
	if area.is_in_group("fish"):
		area.get_eaten()
#		$Bite.play()


func get_new_direction():
	randomize()
	var _dir = 0
	if travel_counter > max_travelling:
		_dir = -1
	elif travel_counter < -max_travelling:
		_dir = 1
	elif randi()%100 > 30:
		_dir = dir * -1
	else:
		_dir = dir
	return( _dir )

func _on_WaitTimer_timeout():
	change_direction()
#	randomize()
#	if randi() % 100 < 40:
#		change_direction()
#	else:
#		dash()