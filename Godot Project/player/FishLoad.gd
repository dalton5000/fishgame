extends Node2D



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