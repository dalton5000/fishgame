extends Resource

enum SPECIES { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC }


var species = {
	SPECIES.COMMON: {
		"type_id": SPECIES.COMMON,
		"name": "Graubarsch",
		"color": Color.lightgray,
		"value": 0
		},
	SPECIES.UNCOMMON: {
		"type_id": SPECIES.UNCOMMON,
		"name": "Grunbarsch",
		"color": Color.greenyellow,
		"value": 0
		},
	SPECIES.RARE: {
		"type_id": SPECIES.RARE,
		"name": "Blaubarsch",
		"color": Color.lightblue,
		"value": 0
		},
	SPECIES.EPIC: {
		"type_id": SPECIES.EPIC,
		"name": "Lilabarsch",
		"color": Color.pink,
		"value": 0
		},
	SPECIES.LEGENDARY: {
		"type_id": SPECIES.LEGENDARY,
		"name": "Turkisbarsch",
		"color": Color.turquoise,
		"value": 0
		},
	SPECIES.MYTHIC: {
		"type_id": SPECIES.MYTHIC,
		"name": "Goldbarsch",
		"color": Color.gold,
		"value": 0
		},
	}