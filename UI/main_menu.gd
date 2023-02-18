extends Control


func _ready():
	update_highscore(0)

func _on_play_button_pressed():
	print("PLAY")


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
