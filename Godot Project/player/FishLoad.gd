extends Node2D


var max_stored_fishes = 5
var stored_fishes = []

var positions = []

onready var player = get_parent().get_parent()
onready var velocity = player.velocity
onready var max_velocity = player.max_velocity

var max_offset = 10

func _ready():
	positions = get_children()

func _physics_process(delta):
	velocity = player.velocity
	var offset_top 	= -velocity / max_velocity * max_offset
#	get_child(9).position.x = offset_top
	for i in positions.size():
		positions[i].position.x = offset_top * i/positions.size()* i/positions.size()* i/positions.size()
		
func store_fish(type):
	helper.log_message("storing fish: " + str(type))
	max_stored_fishes = upgrade_data.get_current_value("storage")
	
	if stored_fishes.size() < max_stored_fishes:
		stored_fishes.append(type)
		positions[stored_fishes.size()-1].get_node("Sprite").frame = type * 5
		return true
	else:
		return false
	
func remove_fish():
	if stored_fishes.size() > 0:
		var type = stored_fishes.back()
		positions[stored_fishes.size()-1].get_node("Sprite").frame = 3
		stored_fishes.pop_back()
		
		return type
	else:
		return false
		
		
func has_fish():
	return( stored_fishes.size() > 0 )