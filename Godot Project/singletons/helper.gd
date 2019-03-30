extends Node

var game
var queue = []

static func make_stringy_number(num):
    var number_string = str(num)
    var index = len(number_string) - 3
    while index > 0:
        number_string = number_string.insert(index, ',')
        index -= 3
    return number_string + " $"
	
func register_game(slug):
	game = slug
	for m in queue:
		log_message(m)
		
func log_message(message):
	if game:
		game.log_message(message)
	else:
		queue.append(message)