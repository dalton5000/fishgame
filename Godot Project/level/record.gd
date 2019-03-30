extends Node2D

signal collected

var song_id = -1
var hook

func _physics_process(delta):
	if hook:
		global_position = hook.global_position


func _on_Area2D_body_entered(body):
	if body.is_in_group("lure"):
		get_hooked(body)


func get_hooked(lure):
	hook = lure
	lure.hook_record(self)
	$Floater.queue_free()
	
func get_collected():
	emit_signal("collected")
	hook = null
	music_data.unlock_random_song()
	queue_free()
	