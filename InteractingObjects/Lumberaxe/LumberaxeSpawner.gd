extends Node2D

@export var player : Node2D

var nextTargets = []

var active=true
signal collide

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		startThrowAtPlayer()

func startThrowAtPlayer():
	# Play scream animation
	$Lumberaxe.throwAtPlayer(player.position)
	# On scream end, start throw

func playDeadAnimation():
	var movepos=Vector2($Lumberaxe.position.x+100,$Lumberaxe.position.y-150)
	$Zaad.position=movepos
	$Zaad.freeze=false
	$Zaad.visible=true
	$Vleugel.position=movepos
	$Vleugel.freeze=false
	$Vleugel.visible=true
func stop():
	active=false

func _on_lumberaxe_collide():
	if active:
		playDeadAnimation()
		emit_signal("collide")
