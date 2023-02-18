class_name GamePlay
extends Node2D

@onready var characterNode=$MapleSeed/MapleSeed
@onready var dedlmaoScreen= $EndScreen/DeadScreen
@onready var winlmaoScreen= $EndScreen/WinScreen
@onready var birdSpawner= $BirdSpawner
@onready var lumberaxeSpawner = $LumberaxeSpawner

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
	RandomObjectSpawnTimer=Timer.new()
	RandomObjectSpawnTimer.connect("timeout", triggerRandomObjectSpawnTick)
	RandomObjectSpawnTimer.set_one_shot(false)
	add_child(RandomObjectSpawnTimer)
	birdSpawner.connect("collide",lose)

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
	emit_signal("win")
	gamePlaying = true

func lose():
	gamePlaying = false
	$Scrolling.stopGame()
	characterNode.stopGame()
	dedlmaoScreen.visible=true
	dedlmaoScreen.play()
	emit_signal("dead")


func _on_dead_screen_dead():
	emit_signal("dead")


func stopGame():
	gamePlaying = false
	$Clouds.visible = false
	$ScrollingClouds.visible = false
	$ScrollingClouds.setScrollSpeed(0)


func startGame():
	gamePlaying = true
	RandomObjectSpawnTimer.start(5)
	$Clouds.visible = true
	$ScrollingClouds.visible = true

