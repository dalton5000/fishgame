extends Camera2D

var target_pos : Vector2
onready var player = get_parent()
onready var target : Node = player

func _process(delta):
	target_pos = target.global_position
	offset.y = lerp(offset.y,target_pos.y-175,0.03)