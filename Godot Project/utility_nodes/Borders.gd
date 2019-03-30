extends Node2D



func _on_Top_area_entered(area):
	if area.is_in_group("fish"):
		area.hit_top_border()
		
	if area.is_in_group("floater"):
		area.hit_top_border()
		
func _on_Left_area_entered(area):
	if area.is_in_group("fish"):
		area.hit_left_border()


func _on_Right_area_entered(area):
	if area.is_in_group("fish"):
		area.hit_right_border()


func _on_Bottom_area_entered(area):
	if area.is_in_group("fish"):
		area.hit_bottom_border()
