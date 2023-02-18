extends Node2D

@export var actualGameScene = preload("res://Gameplay.tscn")

@onready var animations = $AnimationPlayer

var currentIteration = 0
var currentDifficultyLevel = 0
var waitForClick = false

func _ready():
	restartLevel()

signal mouseClicked

func _input(event):
	if event.is_action_pressed("mouse_down") and waitForClick:
		mouseClicked.emit()

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
	animations.animation_finished.connect(
		func(_a): 
#			pass,
			waitAndStart(gameInstance),
		CONNECT_ONE_SHOT
	)
	animations.play("fade_out")


func waitAndStart(game, time=2):
	get_tree().create_timer(time).timeout.connect(
		func(): GameState.change(GameState.STATE.PLAYING),
		CONNECT_ONE_SHOT
	)

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
	waitForClick = true
	$ClickToContinue.visible = true
	mouseClicked.connect(
		func(): 
			restartGracefully()
			waitForClick = false
			$ClickToContinue.visible = false,
		CONNECT_ONE_SHOT
	)
	# Als animaties klaar zijn dan moogt ge herstarten
	

func restartGracefully():
	animations.animation_finished.connect(
		func(_anim):
			get_tree().create_timer(1).timeout.connect(
				func():
					restartLevel()
			),
		CONNECT_ONE_SHOT
	)
	animations.play_backwards("fade_out")

func _on_game_lost(reason: Death.REASON = Death.REASON.UNKNOWN):
	$GAMEPLAY.stopGame()
	
	# Start de death animaties + ga terug naar start, je krijgt geen 2 miljoen
	
	# Als de animaties klaar zijn, dan moogt ge terug naar main menu
	removeGameplay()
	print("Stukske loser")
	
	
