extends Control

func play():
	visible = true
	$AudioStreamPlayer.play()


func _on_button_pressed():
	get_tree().reload_current_scene()
