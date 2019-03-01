extends Tween
class_name FadeOutTween
var target_node

func fade_out(target):
	interpolate_property(target,"modulate",Color.white,Color(1, 1, 1, 0),0.6,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	start()
	target_node = target
	
func _on_Tween_tween_completed(object, key):
	target_node.queue_free()