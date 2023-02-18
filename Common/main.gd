class_name GamePlay
extends Node2D

@onready var characterNode=$MapleSeed/MapleSeed
@onready var winlmaoScreen= $EndScreen/WinScreen
@onready var birdSpawner= $BirdSpawner
@onready var lumberaxeSpawner = $LumberaxeSpawner
@onready var victoryManager = $VictoryManager as VictoryManager

@export var difficultyLevel = 0

#Use seperate timer to handle random objects, as we want this to be based om actual time and not any physics process/framerate
#Counting the delta would also work, but I prefer this
var RandomObjectSpawnTimer = null
var rng = RandomNumberGenerator.new()

#This variable gets modified by the root node in main.tscn
var difficulty = 100

var gamePlaying = false

signal win
signal dead

func _ready():
	characterNode.position=Vector2(-478,-200)
#	GameState.DEBUG_PLS()
	GameState.stateChanged.connect(_on_gameState_changed)
	RandomObjectSpawnTimer=Timer.new()
	RandomObjectSpawnTimer.connect("timeout", triggerRandomObjectSpawnTick)
	RandomObjectSpawnTimer.set_one_shot(false)
	add_child(RandomObjectSpawnTimer)
	birdSpawner.connect("collide",lose)
	victoryManager.victoryAnimationsCompleted.connect(
		func(): win.emit()
	)
	

func _on_gameState_changed(to: GameState.STATE):
	match to:
		GameState.STATE.PLAYING:
			gamePlaying = true
		GameState.STATE.STOPPED:
			gamePlaying = false


func _on_ground_body_entered(body):
	if body == characterNode:
		gamePlaying = false
		$Scrolling.stopGame()
		$ScrollingClouds.setScrollSpeed(0)
		characterNode.stopGame()
		$VictoryManager.start()
#		emit_signal("win")
#		winlmaoScreen.visible=true
#		winlmaoScreen.play()
		
func triggerRandomObjectSpawnTick():
	rng.randomize()
	var number = rng.randi_range(1,10)
	if(0 <= difficulty) and gamePlaying:
#		birdSpawner.vliegVogeltjeVlieg()
		lumberaxeSpawner.startThrowAtPlayer()
	
func _on_win_screen_win():
#	emit_signal("win")
	gamePlaying = true

func lose():
	gamePlaying = false
	$Scrolling.stopGame()
	characterNode.stopGame()
	emit_signal("dead")


func _on_dead_screen_dead():
	emit_signal("dead")


func stopGame():
	gamePlaying = false
	$ScrollingClouds.visible = false
	$ScrollingClouds.setScrollSpeed(0)


func startGame():
	gamePlaying = true
	RandomObjectSpawnTimer.start(5)
	$Clouds.visible = true
	$ScrollingClods.visible = true
	
#used to hide the player node on death (where another animation will be played)
func hidePlayer():
	$MapleSeed.visible=false
	
func hitTree():
	$Scrolling/Tree.hitMe()
	
func setNextGradient(texture):
	$Scrolling/CanvasLayer/NextGradient.texture = texture

func setCurrentGradient(texture):
	$Scrolling/CanvasLayer/Gradient.texture = texture
