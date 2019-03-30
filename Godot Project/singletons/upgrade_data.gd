extends Node

var dummy = {
	"Dummy": {
		"description": "will do this",
		"flavor_text": "everbody needs one of these",
		"unit" : "range",
		"cost": [
			50,100,200
			],
		"values": [
			0, 1, 2, 3
			],
		"displayed_values": [
			0,1,2,3
			]
		}
		}

var upgrades = {
	"rod": {
		"displayed_name" : "Rod",
		"category": "fishing",
		"description": "Throw your hook further out",
		"flavor_text": "",
		"unit" : "% range",
		"cost": [
			50,100,150
			],
		"values": [
			1, 1.2, 1.4, 1.6
			],
		"displayed_values": [
			"100%", "200%","300%","400%"
			],
		"value_name": "throwing range"
		},
		
	"spinner": {
		"displayed_name" : "Spinner",
		"category": "fishing",
		"description": "Pull your hook in faster",
		"flavor_text": "",
		"cost": [
			100,150,200
			],
		"values": [
			1, 1.5, 2, 2.5
			],
		"displayed_values": [
			"100%", "150%","200%","250%"
			],
		"value_name": "pulling speed"
		},
	"line": {
		"displayed_name" : "Line",
		"category": "fishing",
		"description": "Fish in deeper waters",
		"flavor_text": "They say the rarest of fish lurk down in the depths.",
		"cost": [
			50,100,200
			],
		"values": [
			1, 2, 3, 4
			],
		"displayed_values": [
			"100%", "200%","300%","400%"
			],
		"value_name": "line length"
		},
	"weight": {
		"displayed_name" : "Weight",
		"category": "fishing",
		"description": "Lets your hook sink faster",
		"flavor_text": "everbody needs one of these",
		"cost": [
			25,50,100
			],
		"values": [
			1, 2, 3, 4
			],
		"displayed_values": [
			"100%", "200%","300%","400%"
			],
		"value_name": "sinking speed"
		},
	"hook": {
		"displayed_name" : "Hook",
		"category": "fishing",
		"description": "Increases the number of fish you can have hooked",
		"flavor_text": "",
		"cost": [
			150,250,300
			],
		"values": [
			3, 4, 5, 6
			],
		"displayed_values": [
			"3", "4","5","6"
			],
		"value_name": "hooked fish"
		},
	"lure": {
		"displayed_name" : "Lure",
		"category": "fishing",
		"description": "Fancy colored",
		"flavor_text": "Fishes love colors",
		"cost": [
			500,1000,2000
			],
		"values": [
			1, 1, 1, 1
			],
		"displayed_values": [
			"?", "?","?","?"
			],
		"value_name": ""
		},
	"storage": {
		"displayed_name" : "Storage",
		"category": "boat",
		"description": "Store more fish on your boat",
		"flavor_text": "",
		"cost": [
			100,200,300
			],
		"values": [
			5, 7, 10, 12
			],
		"displayed_values": [
			"6", "7","10","12"
			],
		"value_name": "fish on board"
		},
	"motor": {
		"displayed_name" : "Motor",
		"category": "boat",
		"description": "Navigate faster through the waves",
		"flavor_text": "motor good",
		"cost": [
			150,300,400
			],
		"values": [
			1, 2, 3, 4
			],
		"displayed_values": [
			"100%", "200%","300%","400%"
			],
		"value_name": "motor speed"
		},
	}
	
var upgrades_bought = {}

func _ready():
	initialize_upgrades_bought()

func initialize_upgrades_bought():
	for upgrade_data in [upgrades]:
		for upgrade in upgrade_data:
			upgrades_bought[upgrade] = 0
	
func get_current_value(upgrade_name):
	var val = upgrades[upgrade_name]["values"][upgrades_bought[upgrade_name]]
	return val
	