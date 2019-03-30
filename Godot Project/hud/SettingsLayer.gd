extends CanvasLayer

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