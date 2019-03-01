extends KinematicBody2D

var velocity_x = 0.0
var impulse = 200.0
var friction = 3.0

func _ready():
	start_dash()

func start_dash():
	velocity_x += impulse

func _physics_process(delta):
	if velocity_x >= friction:
		velocity_x -= friction
	
	if velocity_x <= friction:
		start_dash()
	
	move_and_slide(Vector2(velocity_x,0))