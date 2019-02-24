extends Camera2D

var target_pos : Vector2
onready var player = get_parent()

func _process(delta):
	offset.y = lerp(offset.y,target_pos.y-175,0.03)