extends RigidBody2D

signal hooked
signal disconnected
var disc = false
var in_water = false setget set_in_water

var lifetime = 0.0

var max_fish = -1
var fish_hooked = 0
func _physics_process(delta):
	lifetime+=delta
	
func on_fish_eaten(fish):
	disconnect_rod()

func disconnect_rod():
	disc=true
	emit_signal("disconnected")
	$Tween.interpolate_property(self,"modulate",Color.white,Color(1, 1, 1, 0),0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	queue_free()

func _on_Area2D_body_entered(body):
	if not disc:
		if fish_hooked < max_fish:
			if body.is_in_group("fish"):
				body.connect("eaten", self, "on_fish_eaten")
				body.get_hooked(self)
				emit_signal("hooked")
				fish_hooked += 1
#		else:
#			disconnect_rod()
			
func set_in_water(slug):
	in_water=slug
	if slug:
		$Splash.play()