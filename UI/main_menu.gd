extends Control

@export var Game : PackedScene = preload("res://GameManager.tscn")

func _ready():
	update_highscore(0)
	$AnimationPlayer.play("fade_out")

func _on_play_button_pressed():
	print("PLAY")
	$AnimationPlayer.animation_finished.connect(
		func(_a): get_tree().change_scene_to_packed(Game)
	)
	$AnimationPlayer.play_backwards("fade_out")


func _on_settings_button_pressed():
	print("Settings")


func _on_credits_button_pressed():
	print("Credits")
	
func update_highscore(score=0):
	if score == 0:
		$Highscore.visible = false
		return
	$Highscore.visible = true
	$Highscore.set_text("Highscore: " + str(score) + " generations")
