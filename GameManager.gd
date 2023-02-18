extends Node2D

@export var actualGameScene = preload("res://Gameplay.tscn")
@export var startScene = preload("res://Gameplay.tscn")
@export var gradients: Array[Texture]
@export var loseScene= preload("res://UI/dead_screen.tscn")


@onready var animations = $AnimationPlayer

var currentIteration = 0
var currentDifficultyLevel = 0
var waitForClick = false

@onready
var currentGradient = gradients[0]
@onready
var nextGradient = gradients[0]

var loseSceneInstance=null
var activeGameInstance : GamePlay=null

func _ready():
	restartLevel()

signal mouseClicked
signal treeHitFrame

func _input(event):
	if event.is_action_pressed("mouse_down") and waitForClick:
		mouseClicked.emit()

func restartLevel():
	
	currentGradient = nextGradient
	nextGradient = gradients.pick_random()
	
	currentIteration += 1
	currentDifficultyLevel += 1
	
	removeGameplay()
	
	# Create new game instance
	activeGameInstance = actualGameScene.instantiate() as GamePlay
	activeGameInstance.name = "GAMEPLAY"
	activeGameInstance.difficultyLevel = currentDifficultyLevel
	activeGameInstance.win.connect(_on_game_ground_reached)
	activeGameInstance.dead.connect(_on_game_lost)
	activeGameInstance.setCurrentGradient(currentGradient)
	activeGameInstance.setNextGradient(nextGradient)
	treeHitFrame.connect(activeGameInstance.hitTree)
	
	# Start game
	add_child(activeGameInstance)
	animations.animation_finished.connect(
		func(_a): 
#			pass,
			waitAndStart(activeGameInstance),
		CONNECT_ONE_SHOT
	)
	animations.play("fade_out")


func waitAndStart(game, time=2):
	animations.animation_finished.connect(
		tree_falling,
		CONNECT_ONE_SHOT
	)
	get_tree().create_timer(time).timeout.connect(
		func(): animations.play("hak"),
		CONNECT_ONE_SHOT
	)

func tree_falling(_a):
	GameState.change(GameState.STATE.PLAYING)
	get_tree().create_timer(3).timeout.connect(
		func(): 
			$AnimationPlayer/chop2.play()
			$AnimationPlayer/treefalls.play(),
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

func restartAfterLose():
	#Maybe reset the entire game in this function isntead of soft reseting like in other wins?
	currentIteration = 0
	currentDifficultyLevel = 0
	remove_child(loseSceneInstance)
	loseSceneInstance=null
	restartLevel()

func _on_game_lost(reason: Death.REASON = Death.REASON.UNKNOWN):
	GameState.change(GameState.STATE.STOPPED)
	
	# Start de death animaties + ga terug naar start, je krijgt geen 2 miljoen
	
	#Wait 3 sec after game loss to play lose animations
	activeGameInstance.hidePlayer()
	get_tree().create_timer(3).timeout.connect(
		func(): 
			removeGameplay()
			loseSceneInstance=loseScene.instantiate()
			loseSceneInstance.setScore(currentIteration)
			add_child(loseSceneInstance)
			loseSceneInstance.connect("restart",restartAfterLose)
			print("Stukske loser"),
		CONNECT_ONE_SHOT
	)
	# Als de animaties klaar zijn, dan moogt ge terug naar main menu
	
	
func hitTree():
	treeHitFrame.emit()
	
