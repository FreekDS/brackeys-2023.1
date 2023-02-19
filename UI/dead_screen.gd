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
	var scoring = Scoring.new()
	if FileAccess.file_exists("user://save.txt"):
		var f = FileAccess.open("user://save.txt", FileAccess.WRITE_READ)
		var sc = int(f.get_line())
		if score > sc:
			f.store_line(str(score))
	else:
		var f = FileAccess.open("user://save.txt", FileAccess.WRITE)
		f.store_line(str(score))
		
func _on_button_menu_pressed():
	$AnimationPlayer.animation_finished.connect(
		func(_a): 
			if ResourceLoader.exists(main_menu):
				var _error = get_tree().change_scene_to_file(main_menu)
	)
	$AnimationPlayer.play_backwards("fade_out")
