extends CanvasLayer

signal closed
signal player_name_entered


onready var result_list = $Control/PanelContainer/VBoxContainer/Results
onready var result_scene = preload("res://hud/scoreboard/ScoreboardEntry.tscn")

onready var highscore_panel = $Control/PanelContainer
onready var highscore_pos = highscore_panel.rect_position

func _ready():
	get_top_ten()
	
	show()
	yield($Motion,"tween_completed")
	set_player_money(game_data.player_money)
	$Control/NamePanel/VBoxContainer/Inputs/Name.text = game_data.player_name
	
func set_player_money(new_score):
	$Control/NamePanel/VBoxContainer/ScoreLabel.text = helper.make_stringy_number(new_score)
	
func fill_highscores():
	for i in range(0,20):
		var url = "http://highscorescorepi.crabdance.com/0"
		var data = {
			"player" : "Fisherman Fred",
			"score" : randi()%10000
			}
		
		data = to_json(data)
		$SendScore.request(url,["Content-Type: application/json"],false,HTTPClient.METHOD_POST,data)
		yield($SendScore,"request_completed")

func get_top_ten():
	_clear_results()
	var headers = [
	"Authorization: Basic ZmlzaGdhbWU6YWxsZXJnZWlsMw=="
	]
	$GetTopTen.request(
#		"http://highscorescorepi.crabdance.com/HANS/1",
		"http://highscorescorepi.crabdance.com/0/3",
		headers,
		false,
		HTTPClient.METHOD_GET,
		"")

func _on_GetTopTen_request_completed(result, response_code, headers, body):
	pass
	if result == 0:
		var dict =JSON.parse(body.get_string_from_utf8()).result	
		for entry in dict:
			_add_result(entry.rank, entry.player, entry.score)
	

func _get_highscore():
	_clear_results()
	var headers = [
	"Authorization: Basic ZmlzaGdhbWU6YWxsZXJnZWlsMw=="
	]
	$GetScore.request(
#		"http://highscorescorepi.crabdance.com/HANS/1",
		"http://highscorescorepi.crabdance.com/0/" + str(game_data.last_ranked),
		headers,
		false,
		HTTPClient.METHOD_GET,
		"")
		
func _on_GetScore_request_completed(result, response_code, headers, body):	
#	pass
#	helper.log_message("recieved answer for get score: " + str(body))
	if result == 0:
		var dict =JSON.parse(body.get_string_from_utf8()).result	
#		helper.log_message("recieved answer for get score: " + str(dict))
		for entry in dict:
			_add_result(entry.rank, entry.player, entry.score)
	show_scorelist()

func _send_highscore():	
	var url = "http://highscorescorepi.crabdance.com/0"

	var data = {
		"player" : game_data.player_name,
		"score" : game_data.player_money
		}
	
	data = to_json(data)
#	var auth = Marshalls.variant_to_base64("fishgame:allergeil3")
	
	var headers = [
		"Content-Type: application/json",
		"Authorization: Basic ZmlzaGdhbWU6YWxsZXJnZWlsMw=="
		]
#	helper.log_message("sending score with name" + game_data.player_name)
	helper.log_message("sending score with money" + str(game_data.player_money))
#	$SendScore.request(url,["Content-Type: application/json"],false,HTTPClient.METHOD_POST,data)
	$SendScore.request(url,headers,false,HTTPClient.METHOD_POST,data)
#	$SendScore.request(url,["Content-Type: application/json", "Authorization: Basic "+auth ],false,HTTPClient.METHOD_POST,data)
	
func _on_SendScore_request_completed(result, response_code, headers, body):
#	var x = body.get_string_from_utf8()
#	print(body.get_string_from_utf8())
	
#	helper.log_message("recieved answer for send score: " + str((body.get_string_from_utf8())))
	helper.log_message("%s, %s, %s, %s" % [result, response_code, headers, body])
	var debug1 =JSON.parse(body.get_string_from_utf8()).result
	helper.log_message(str(debug1))
	if result == 0:
		game_data.last_ranked = body.get_string_from_utf8()
		_get_highscore()

func set_player_name(new_name):
	$Control/NamePanel/VBoxContainer/Inputs/Name.text = new_name
	
func _add_result(rank, player,score):
	var label = result_scene.instance()
	label.entry_name = player
	label.rank = rank
	label.score = score
	if int(label.rank) == int(game_data.last_ranked):
		label.highlighted = true
	result_list.add_child(label)
	
func _clear_results():
	for i in result_list.get_child_count():
		result_list.get_child(i).queue_free()


func show():
	$Control.rect_position = Vector2(0,-get_viewport().size.y)
	$Motion.interpolate_property($Control,"rect_position",Vector2(0,-get_viewport().size.y), Vector2(0,0), 1.0,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Motion.start()
	$Control.show()
	
func hide():
	$Control.rect_position = Vector2(0,-get_viewport().size.y)
	$Motion.interpolate_property($Control,"rect_position",Vector2(0,0),Vector2(0,-get_viewport().size.y), 1.0,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Motion.start()
	yield($Motion,"tween_completed")
	emit_signal("closed")
	
func show_scorelist():
	highscore_panel.rect_position = Vector2(0,-$Control.rect_size.y)
	$Motion.interpolate_property(highscore_panel,"rect_position",highscore_pos+Vector2(0,-$Control.rect_size.y), highscore_pos, 2.5,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Motion.start()
	highscore_panel.show()
	
func hide_scorelist():
	highscore_panel.rect_position = Vector2(0,-$Control.rect_size.y)
	$Motion.interpolate_property(highscore_panel,"rect_position", highscore_pos, highscore_pos+Vector2(0,-$Control.rect_size.y), 2.5,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	$Motion.start()
	


func _on_Fill_pressed():
	fill_highscores()


func _on_Name_text_entered(new_text):
	game_data.player_name=new_text
	emit_signal("player_name_entered",new_text)

func _on_CloseButton_pressed():
	hide()


func _on_submit_pressed():
	
	if $Control/NamePanel/VBoxContainer/Inputs/Name.text == "": pass
	else: 
		game_data.player_name = $Control/NamePanel/VBoxContainer/Inputs/Name.text
		hide_scorelist()
		yield($Motion,"tween_completed")
		_send_highscore()
