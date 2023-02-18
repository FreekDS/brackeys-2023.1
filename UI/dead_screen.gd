extends Control

signal restart


func _on_button_pressed():
	emit_signal("restart")

func setScore(score:int):
	$Text/Score.text=str(score)
