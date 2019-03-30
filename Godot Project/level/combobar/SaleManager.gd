extends Node

var time_between_sales = 60.0

var base_sale_duration = 90.0
var base_sale_reward = 50.0

var sale_message_template = "%s bonus for this combo:"

var sale_tiers = {
	0 : {
		"reward_bonus" : 1.0,
		"time_factor" : 1.25,
		},
	1 : {
		"reward_bonus" : 1.5,
		"time_factor" : 1.0,
		},
	2 : {
		"reward_bonus" : 2.0,
		"time_factor" : 0.75,
		},
	3 : {
		"reward_bonus" : 3.0,
		"time_factor" : 0.5,
		}
	}

onready var parent = get_parent()

func _ready():
	yield(get_tree(),"idle_frame")
	start_sale()

func start_sale():
	randomize()
#	var species = randi() % 4
	var species = 1
	var tier = randi() % sale_tiers.size()
	
	var reward = base_sale_reward * sale_tiers[tier]["reward_bonus"] * (species+1)
	var time = base_sale_duration * sale_tiers[tier]["time_factor"]
	
	
	parent.start_sale(species, tier, time, reward)
	parent.emit_signal("sale_started", species, tier)
	
	$Timer.wait_time = base_sale_duration + time_between_sales
	$Timer.start()
	
func _on_Timer_timeout():
	start_sale()