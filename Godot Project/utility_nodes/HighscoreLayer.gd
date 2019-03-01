extends CanvasLayer

onready var result_list = $Control/PanelContainer/VBoxContainer/Results
onready var result_scene = preload("res://hud/scoreboard/ScoreboardEntry.tscn")

var last_rank = 1

onready var highscore_panel = $Control/PanelContainer
onready var highscore_pos = highscore_panel.rect_position

#func _ready():
#	$Control.hide()


func fill_highscores():
	for i in range(0,20):
		var url = "http://highscorescorepi.crabdance.com/HANS"
		var data = {
			"player" : "Fisherman Fred",
			"score" : randi()%10000
			}
		
		data = to_json(data)
		$SendScore.request(url,["Content-Type: application/json"],false,HTTPClient.METHOD_POST,data)
		yield($SendScore,"request_completed")


func _on_Button_pressed():
	if $Control/NamePanel/VBoxContainer/Inputs/Name.text == "": pass
	else: _send_highscore()
	
func _get_highscore():
	_clear_results()
	var headers = [
	"Authorization: Basic ZmlzaGdhbWU6YWxsZXJnZWlsMw=="
	]
	$GetScore.request(
#		"http://highscorescorepi.crabdance.com/HANS/1",
		"http://highscorescorepi.crabdance.com/0/" + str(last_rank),
		headers,
		false,
		HTTPClient.METHOD_GET,
		"")
		
func _on_GetScore_request_completed(result, response_code, headers, body):	
#	pass
	
	var dict =JSON.parse(body.get_string_from_utf8()).result	
	for entry in dict:
		_add_result(entry.rank, entry.player, entry.score)
	show_scorelist()
	

func _send_highscore():	
	var url = "http://highscorescorepi.crabdance.com/0"
	var player_name = str($Control/NamePanel/VBoxContainer/Inputs/Name.text)

	var data = {
		"player" : player_name,
		"score" : 3000
		}
	
	data = to_json(data)
	var auth = Marshalls.variant_to_base64("fishgame:allergeil3")
	
	var headers = [
		"Content-Type: application/json",
		"Authorization: Basic ZmlzaGdhbWU6YWxsZXJnZWlsMw=="
		]
#	$SendScore.request(url,["Content-Type: application/json"],false,HTTPClient.METHOD_POST,data)
	$SendScore.request(url,headers,false,HTTPClient.METHOD_POST,data)
#	$SendScore.request(url,["Content-Type: application/json", "Authorization: Basic "+auth ],false,HTTPClient.METHOD_POST,data)
	
func _on_SendScore_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	
	last_rank = body.get_string_from_utf8()
	_get_highscore()


		
		
func _add_result(rank, player,score):
	var label = result_scene.instance()
	label.entry_name = player
	label.rank = rank
	label.score = score
	if int(label.rank) == int(last_rank):
		label.highlighted = true
	result_list.add_child(label)
	
func _clear_results():
	for i in result_list.get_child_count():
		result_list.get_child(i).queue_free()

func _on_Send_pressed():
	_send_highscore()

func show():
	$Control.show()
	
func show_scorelist():
	highscore_panel.rect_position = Vector2(0,-$Control.rect_size.y)
	$Motion.interpolate_property(highscore_panel,"rect_position",highscore_pos+Vector2(0,-$Control.rect_size.y), highscore_pos, 2.5,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Motion.start()
	highscore_panel.show()
	
func hide():
	$Control.hide()




func _on_Fill_pressed():
	fill_highscores()
