extends Node2D

func _physics_process(delta):
	
	$ParallaxBackground/Horizon.motion_offset.x += delta*5