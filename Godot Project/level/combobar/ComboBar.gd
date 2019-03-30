extends Node2D


signal combo_won
signal combo_lost
signal sale_started

var combo_type = 0
var combo_timeout = 3.0
var combo_duration = 20.0
var combo_reward = 50

var combo_counter = 0
var sale_timer = 0.0

var active = false

onready var tween = $Tween
onready var color_tween = $ColorTween
onready var fish_icons = $Bar/FishIcons

onready var coin_sounds = $Sounds/Combo.get_children()
var sound_queue = []
var sound_playing = false

func start_sale(type, tier, duration = combo_duration, reward = combo_reward):
	
	_reset()
	
	combo_duration = duration
	combo_type = type
	combo_reward = reward
	$Bar/Background.frame = tier
	active = true
	
	_show_anim()

func _physics_process(delta):
	if active:
		sale_timer += delta
		$ProgressBar.value = (combo_duration-sale_timer)/combo_duration*100
		if sale_timer > combo_duration:
			_combo_failed()
		
func _show_anim():
	for icon in fish_icons.get_children():
		icon.frame = combo_type
		icon.modulate = Color(1.0,1.0,1.0,0.4)
#	tween.interpolate_property($Bar, "position", Vector2(0,-20),Vector2(0,0),1.0,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
#	tween.start()
	color_tween.interpolate_property(self,"modulate",Color(1.0,1.0,1.0,0.0),Color.white,1.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	color_tween.start()
	show()
#	yield(tween,"tween_completed")
	
func _lose_anim():
	tween.interpolate_property($Bar, "position", Vector2(0,0),Vector2(0,50),1.5,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	tween.start()
	color_tween.interpolate_property(self,"modulate",Color.white,Color(1.0,0.0,0.0,0.0),1.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	color_tween.start()
	yield(tween,"tween_completed")
	hide()
	
func _win_anim():
	color_tween.interpolate_property(self,"modulate",Color.white,Color(0.0,1.0,0.0,0.0),1.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	color_tween.start()
	yield(color_tween,"tween_completed")
	hide()
	
func _combo_failed():
	active = false
	$Sounds/ComboFail.play()
	emit_signal("combo_lost")
	_lose_anim()

func _combo_success():
	active = false
	
	for icon in fish_icons.get_children():
		icon.frame = 8
		
	yield(get_tree().create_timer(0.8),"timeout")
	_win_anim()
	$Sounds/ComboComplete.play()
	emit_signal("combo_won",combo_reward)

func play_sound(idx):
	if sound_playing:
		sound_queue.append(idx)
	else:
		coin_sounds[idx].play()
		

func _reset():
#	for child in fish_icons.get_children():
#		child.hide()
	combo_counter = 0
		
	
func _on_fish_collected(type):
	print("combo collected type: " + str(type))
	
	if active:
		if type == combo_type:
			fish_icons.get_child(combo_counter).modulate = Color.white
			fish_icons.get_child(combo_counter).frame = combo_type
			combo_counter += 1
			coin_sounds[combo_counter-1].play()
			
			if combo_counter == 3:
				_combo_success()
			
		elif combo_counter == 0:
			pass
			
		else:
			fish_icons.get_child(combo_counter).modulate = Color.white
			fish_icons.get_child(combo_counter).frame = 9
			_combo_failed()
		