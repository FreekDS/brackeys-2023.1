extends Node2D

@export var actualGameScene = preload("res://Gameplay.tscn")

var currentIteration = 0
var currentDifficultyLevel = 0

func _ready():
	restartLevel()


func restartLevel():
	currentIteration += 1
	currentDifficultyLevel += 1
	
	removeGameplay()
	
	# Create new game instance
	var gameInstance : GamePlay = actualGameScene.instantiate() as GamePlay
	gameInstance.name = "GAMEPLAY"
	gameInstance.difficultyLevel = currentDifficultyLevel
	gameInstance.win.connect(_on_game_ground_reached)
	gameInstance.dead.connect(_on_game_lost)
	
	# Start game
	add_child(gameInstance)
	gameInstance.startGame()

func removeGameplay():
	var gamePlay = get_node_or_null("GAMEPLAY")
	if gamePlay != null:
		gamePlay.name = "WILL_BE_REMOVED"	# Ensure no clash with new game instance name
		gamePlay.stopGame()
		gamePlay.queue_free()


func _on_game_ground_reached():
	$GAMEPLAY.stopGame()
	print("Stukske winnaar")
	
	# Start de victory animaties, nen welgemeende proficiat
	
	# Als animaties klaar zijn dan moogt ge herstarten
	removeGameplay()


func _on_game_lost(reaon: Death.REASON = Death.REASON.UNKNOWN):
	$GAMEPLAY.stopGame()
	
	# Start de death animaties + ga terug naar start, je krijgt geen 2 miljoen
	
	# Als de animaties klaar zijn, dan moogt ge terug naar main menu
	removeGameplay()
	print("Stukske loser")
	
	
