extends Node2D

export var species = 0
export var amount = 0


onready var fish_scene = preload("res://Fish/Fish.tscn")

onready var fish_holder = get_node("/root/Game/Level/Fishes")
func _ready():
	for i in amount:
		spawn_fish(species)

func spawn_fish(type):
	
	var new_fish = fish_scene.instance()
	
	var fish_pos = Vector2()
	var parent 
	
	var centerpos
	var size
	
	parent = $Fishes
	centerpos = $Area2D/CollisionShape2D.global_position
	size = $Area2D/CollisionShape2D.shape.extents
	
	fish_pos.x = (randi() % int(size.x*2)) - (size.x) + centerpos.x
#	fish_pos.x = 800
	fish_pos.y = (randi() % int(size.y*2)) - (size.y) + centerpos.y
#	fish_pos.y = 200

#	parent.add_child(new_fish)
	
	var fishtype = randi() % fish_data.species.size()
	new_fish.type_id = type
#	new_fish.type_id = fishtype
	
	call_deferred("add_child",new_fish)
	yield(get_tree(), "idle_frame")
	new_fish.global_position = fish_pos