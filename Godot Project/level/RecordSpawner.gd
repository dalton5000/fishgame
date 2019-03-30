extends Node2D

var time_between_records = 60.0

var record_scene = preload("res://level/record.tscn")

func _ready():
	spawn_record() 
	
func spawn_record():
#	helper.log_message("spawning record")
	var new_record = record_scene.instance()
	add_child(new_record)
	new_record.connect("collected", self, "on_record_collected")
	
func on_record_collected():
#	helper.log_message("record collected")
	if music_data.unlocked_songs.size() < music_data.songs.size():
		$Timer.wait_time = time_between_records
		$Timer.start()

func _on_Timer_timeout():
	spawn_record()
