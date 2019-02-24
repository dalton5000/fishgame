extends Node2D

var max_fish = 35


var living_fish_count_top = 0
var living_fish_count_bottom = 0
var fish_scene = preload("res://Fish/Fish.tscn")

var golden_count = 0
var purple_count_top = 0
var purple_count_bottom = 0
var blue_count_bottom = 0

var min_golden = 3
var min_purple_top = 3
var min_purple_bottom = 6
var min_blue_bottom = 15

func _ready():
	check_population()

func check_population():
	
	golden_count = get_tree().get_nodes_in_group("golden").size()
	purple_count_top = get_tree().get_nodes_in_group("purple_top").size()
	purple_count_bottom = get_tree().get_nodes_in_group("purple_bottom").size()
	blue_count_bottom = get_tree().get_nodes_in_group("blue_bottom").size()
	
	living_fish_count_top = get_tree().get_nodes_in_group("fish_top").size()
	
	print("living golden fish: %s" % golden_count)
	
	var missing_fish_top = max_fish - living_fish_count_top
	for i in range(0, missing_fish_top):
		spawn_fish("top")
		
	living_fish_count_bottom = get_tree().get_nodes_in_group("fish_bottom").size()
	var missing_fish_bottom = max_fish - living_fish_count_bottom
	for i in range(0, missing_fish_bottom):
		spawn_fish("bottom")
	
	
func spawn_fish(where):
	
	var new_fish = fish_scene.instance()
	
	var fish_pos = Vector2()
	var parent 
	
	var centerpos
	var size
	
	match where:
		"top":
			if purple_count_top < min_purple_top:
				new_fish.type = 2
				purple_count_top += 1
				
			new_fish.add_to_group("fish_top")
			parent = $Top
			centerpos = $Top/CollisionShape2D.global_position
			size = $Top/CollisionShape2D.shape.extents
		"bottom":
			if golden_count < min_golden:
				new_fish.type = 3
				golden_count += 1
			elif purple_count_bottom < min_purple_bottom:
				new_fish.type = 2
				purple_count_bottom += 1
			elif blue_count_bottom < min_blue_bottom:
				new_fish.type = 1
				blue_count_bottom += 1
				
			new_fish.add_to_group("fish_bottom")
			centerpos = $Bottom/CollisionShape2D.global_position
			size = $Bottom/CollisionShape2D.shape.extents
			parent = $Bottom
	
	fish_pos.x = (randi() % int(size.x*2)) - (size.x) + centerpos.x
	fish_pos.y = (randi() % int(size.y*2)) - (size.y) + centerpos.y
	new_fish.global_position = fish_pos
#	parent.add_child(new_fish)
	
	call_deferred("add_child",new_fish)
#	centerpos = colshape2d.position + area2d.position
#	size = colshape2d.shape.extents
#	positionInArea.x = (randi() % size.x) - (size.x/2) + centerpos.x
#	positionInArea.y = (randi() % size.y) - (size.y/2) + centerpos.y







func _on_CheckTimer_timeout():
	check_population()
