extends RigidBody2D
var type = 0

func get_collected():
	queue_free()

func entered_water():
	$Splash.play()
	$FadeOutTween.fade_out(self)