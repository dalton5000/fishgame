extends RigidBody2D

signal disconnected
signal entered_water
signal collected

func disconnect_rod():
	emit_signal("collected")
	emit_signal("disconnected")
	yield(get_tree().create_timer(0.3),"timeout")	
	queue_free()
	
func entered_water():
	emit_signal("entered_water")
	$Sounds/Splash.play()