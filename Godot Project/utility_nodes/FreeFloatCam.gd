extends Camera2D

var current_speed = 0
var speed = 10

#func make_current(slug):
#	current=slug

	
func _physics_process(delta):
	if current:
		if Input.is_action_pressed("ui_left"):
			position.x -= speed
		if Input.is_action_pressed("ui_right"):
			position.x += speed
		if Input.is_action_pressed("ui_up"):
			position.y -= speed
		if Input.is_action_pressed("ui_down"):
			position.y += speed