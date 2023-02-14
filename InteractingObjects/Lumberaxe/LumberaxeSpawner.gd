extends Node2D

@export var player : Node2D

var nextTargets = []

func _input(event):
	if event.is_action_pressed("ui_accept"):
		startThrowAtPlayer()

func startThrowAtPlayer():
	# Play scream animation
	$Lumberaxe.throwAtPlayer(player.position)
	# On scream end, start throw
