extends RigidBody2D
signal eaten

var type = 0 setget set_type

onready var fade_tween = $FadeOutTween

func get_collected():
	queue_free()

func entered_water():
	$Splash.play()
	$FadeOutTween.fade_out(self)
	
func set_type(slug):
	type = slug
	$Sprite.frame = type * 5

func get_eaten():
	$Sprite.frame = 4
	linear_velocity=linear_velocity/5
	emit_signal("eaten")
	fade_tween.fade_out($Sprite)
	yield(fade_tween,"tween_completed")
	queue_free()