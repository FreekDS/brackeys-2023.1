extends Control


func _ready():
	update_highscore(100)

func _on_play_button_pressed():
	print("PLAY")


func _on_settings_button_pressed():
	print("Settings")


func _on_credits_button_pressed():
	print("Credits")
	
func update_highscore(score=0):
	$Highscore.set_text("Highscore: " + str(score) + " generations")
