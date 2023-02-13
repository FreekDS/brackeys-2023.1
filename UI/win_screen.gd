extends Control

signal win

func play():
	visible = true
	$AudioStreamPlayer.play()


func _on_button_pressed():
	emit_signal("win")
