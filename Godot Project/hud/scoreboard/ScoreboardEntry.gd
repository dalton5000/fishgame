extends PanelContainer

var entry_name setget set_entry_name
var rank setget set_rank
var score setget set_score

var highlighted = false setget set_highlighted

func set_highlighted(slug):
	highlighted=slug
	if highlighted:
		modulate= Color.yellow

func set_entry_name(slug):
	entry_name = str(slug)
	$HBoxContainer/Name.text = entry_name

func set_rank(slug):
	rank = str(slug)
	$HBoxContainer/Rank.text = rank
	
func set_score(slug):
	score = str(slug)
	$HBoxContainer/Score.text = score + "$"