extends Control


@export_file("*.tscn")
var main_menu : String = "res://UI/main_menu.tscn"

signal restart


func _ready():
	$AnimationPlayer.play("fade_out")

func _on_button_pressed():
	emit_signal("restart")

func setScore(score:int):
	$Text/Score.text=str(score)


func _on_button_menu_pressed():
	$AnimationPlayer.animation_finished.connect(
		func(_a): 
			if ResourceLoader.exists(main_menu):
				var _error = get_tree().change_scene_to_file(main_menu)
	)
	$AnimationPlayer.play_backwards("fade_out")
