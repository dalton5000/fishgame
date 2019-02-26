extends CanvasLayer

onready var result_list = $Control/Results

func _ready():
	pass

func _on_Button_pressed():
	_get_highscore()

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	var dict =JSON.parse(body.get_string_from_utf8()).result
	for entry in dict:
		_add_result(entry.name)
	
func _get_highscore():
	_clear_results()
	$HTTPRequest.request("https://jsonplaceholder.typicode.com/users")

func _add_result(slug):
	var label = Label.new()
	slug = "%s. %s" % [str(result_list.get_child_count()+1), slug]
	label.text = str(slug)
	result_list.add_child(label)
	
func _clear_results():
	for i in result_list.get_child_count():
		result_list.get_child(i).queue_free()