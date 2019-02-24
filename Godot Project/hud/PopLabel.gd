extends Node2D

onready var label_amount = $Label_Amount

enum ICON {COIN=0, SPINE=1}

export (Vector2) var final_scale = Vector2(1.0, 1.0)
export (float) var float_distance = 30
export (float) var duration = 1.0
export (String) var text = "not set"
	

	
func pop_string(text : String, color : Color) -> void:
	$Label_Amount.set("custom_colors/font_color", color)
	
	$Label_Amount.text = text
	$Tween.interpolate_property(self, "position", position, 
			position + Vector2(0, -float_distance), duration, Tween.TRANS_BACK,
			Tween.EASE_IN)
	var transparent = modulate
	transparent.a = 0.0
	$Tween.interpolate_property(self, "modulate", modulate, transparent,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()
