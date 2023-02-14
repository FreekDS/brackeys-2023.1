extends Control

signal dead

func play():
	visible = true
	$AudioStreamPlayer.play()


func _on_button_pressed():
	emit_signal("dead")
