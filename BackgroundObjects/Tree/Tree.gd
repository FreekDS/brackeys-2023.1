extends Node2D

var originalPos = Vector2.ZERO

func hitMe():
	var randx = randf_range(-10, 10)
	var randy = randf_range(-10, 10)
	originalPos = position
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", position + Vector2(randx, randy), .025)
	tween.tween_property(self, "position", originalPos, .025)
	tween.play()

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		hitMe()
