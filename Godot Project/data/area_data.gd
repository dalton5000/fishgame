extends Node

var data_path = "res://data/area_data.tsv"

const AREAS = 17
const FISHES = 6

var spawn_areas = {}


func _ready():
	load_from_tsv()
	
func load_from_tsv():
	spawn_areas = {}
	var file = CSVFile.new()
	var err = file.load(data_path)
	var map = {}
	map = file.get_map()
	var values = map.keys()
	
	for id in range(0+1,AREAS+1):
		var new_area = {}
		var entry = map[str(id)]
		new_area["population_min"] = entry[1]
		new_area["population_max"] = map[str(id)][2]
		new_area["spawn_chances"] = {}
		for fish in range(0,FISHES):
			new_area["spawn_chances"][fish] = map[str(id)][fish+3]
		spawn_areas[id] = new_area
		