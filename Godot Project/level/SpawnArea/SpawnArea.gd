tool
extends Node2D
class_name SpawnArea

var refill_interval = 30.0
var waiting_for_refill = false
var in_viewport = false

export(int) var id = -1 setget set_id

export var width = 64.0 setget set_width
export var height = 64.0 setget set_height

var size = Vector2(width, height)
var pos = -Vector2(width, height)/2

export(Color) var border_color = Color(1.0, 1.0, 0.5, 1.0) setget set_border_color
var area_color = Color(1.0, 1.0, 0.5, 0.5)

var id_label_template = "Spawn Area: %s"

var groupname = ""

onready var fish_scene = preload("res://Fish/Fish.tscn")

func refill():
		var current_amount = get_living_fish_count()
		var min_amount = area_data.spawn_areas[id]["population_min"]
		var max_amount = area_data.spawn_areas[id]["population_max"]
		
		var target_amount = rand_range(float(min_amount), float(max_amount))
		var amount_to_spawn = target_amount - current_amount
		amount_to_spawn = int(clamp(amount_to_spawn,0.0,amount_to_spawn))
		
		for fish in amount_to_spawn:
			
			var spawn_type = -1
		
			var dice = randi() % 100
			
			var chance_counter = 0
			
			for type in range(area_data.FISHES-1,-1,-1):
				var chance = int(area_data.spawn_areas[id]["spawn_chances"][type])
				chance_counter += chance
				if dice < chance_counter:
					spawn_fish(type)
					break
		$RefillTimer.start()
		
func get_living_fish_count():
	var amount = get_tree().get_nodes_in_group(groupname).size()
	return (amount)

func _ready():
	randomize()
	groupname = "area"+str(id)+ "_" +str(randi()%10000)
	
#	if not Engine.editor_hint:
	if id in area_data.spawn_areas:
		$Info/IDLabel.hide()
		refill()
#		helper.log_message("should spawn")
	else:
		print("spawn area couldn't find data for id:" + str(id))
	
	
	$RefillTimer.wait_time = refill_interval
	
	
func _process(delta):
	if Engine.editor_hint:
		update()


func fill():
	pass

func spawn_fish(type):
	
	var new_fish = fish_scene.instance()
	
	var fish_pos = Vector2()
	
	fish_pos.x = (randi() % int(size.x)) - (size.x/2)
	fish_pos.y = (randi() % int(size.y)) - (size.y/2)
	
	var fishtype = randi() % fish_data.species.size()
	new_fish.type_id = type
	new_fish.add_to_group(groupname)
	call_deferred("add_child",new_fish)
	yield(get_tree(), "idle_frame")
	new_fish.position = fish_pos

	
### DRAWING

func _draw():
    if Engine.editor_hint:
        draw_rect(Rect2(pos, size), area_color, true)
        draw_rect(Rect2(pos, size), border_color, false)
    else:
        pass
		
func set_border_color(slug):
	border_color = slug
	area_color = border_color
	$Info/IDLabel.set("custom_colors/font_color", border_color)
	area_color.a = 0.5

func set_id(slug):
	id = int(slug)
	
	if Engine.editor_hint:
		var label= get_node_or_null("Info/IDLabel")
		if label:
			label.text = id_label_template % str(id)

func set_width(slug):
	width = slug
	size = Vector2(width, height)
	pos = -Vector2(width, height)/2

func set_height(slug):
	height = slug
	size = Vector2(width, height)
	pos = -Vector2(width, height)/2

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	in_viewport = false
	if waiting_for_refill:
		refill()
		waiting_for_refill = false


func _on_RefillTimer_timeout():
	if in_viewport:
		waiting_for_refill = true
	else:
		refill()


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	in_viewport = true
