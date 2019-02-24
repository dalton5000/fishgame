extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
		
	$AudioStreamPlayer2D.pitch_scale= 0.4+randf()*0.4
	$Timer.wait_time = randf()*30.0
	$Timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$CPUParticles2D.emitting=true
	$Timer.wait_time = randf()*30.0
	$CPUParticles2D.restart()
	if randf()<0.08:
		$AudioStreamPlayer2D.play()
