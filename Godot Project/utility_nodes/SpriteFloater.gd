extends Node2D

onready var parent = get_parent()
var offset_y

export var floating_speed = 2.0
export var floating_height = 1.0
var lifetime = randf()*60.0

func _ready():
	offset_y = parent.position.y

func _physics_process(delta):
	lifetime+=delta * floating_speed
	parent.position.y = offset_y + sin(lifetime) * floating_height