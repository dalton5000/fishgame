extends RigidBody2D

signal disconnected
signal entered_water
signal collected

var hooked_fish = []
var hooked_record

#func _ready():
#	mass = upgrade_data.get_current_value("weight")

func hook_record(record):
	hooked_record = record

func hook_fish(type_id):
	helper.log_message("hooked fish: " +str(type_id))
	hooked_fish.append(type_id)

func unhook_fish(type_id):
	if type_id in hooked_fish:
		hooked_fish.erase(type_id)

func disconnect_rod():
	emit_signal("disconnected")
	yield(get_tree().create_timer(0.3),"timeout")	
	queue_free()
	
func get_collected():
	emit_signal("collected")
	linear_velocity = linear_velocity / 8
	if hooked_record:
		hooked_record.get_collected()
	
func entered_water():
	gravity_scale = upgrade_data.get_current_value("weight")
	emit_signal("entered_water")
	$Sounds/Splash.play()