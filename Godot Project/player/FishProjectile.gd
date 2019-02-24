extends RigidBody2D

var value = -1
var type = -1

var collected = false setget set_collected



func set_collected(slug):
	collected=slug
	if collected:
		linear_velocity=linear_velocity/3
		applied_torque=applied_torque/10
		$Tween.interpolate_property(self,"modulate",Color.white,Color(1, 1, 1, 0),0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween,"tween_completed")
		queue_free()
		
func get_eaten():
	$Sprite.frame=6
	set_collected(true)

func hit_water():
	set_collected(true)