extends Node2D

@onready var characterNode=$MapleSeed/MapleSeed
@onready var dedlmaoScreen= $EndScreen/DeadScreen
@onready var winlmaoScreen= $EndScreen/WinScreen
@onready var birdSpawner= $BirdSpawner
@onready var lumberaxeSpawner = $LumberaxeSpawner
#Use seperate timer to handle random objects, as we want this to be based om actual time and not any physics process/framerate
#Counting the delta would also work, but I prefer this
var RandomObjectSpawnTimer = null
var rng = RandomNumberGenerator.new()

#This variable gets modified by the root node in main.tscn
var difficulty=100

var gamePlaying = true

signal win
signal dead
func _ready():
	RandomObjectSpawnTimer=Timer.new()
	RandomObjectSpawnTimer.connect("timeout", triggerRandomObjectSpawnTick)
	RandomObjectSpawnTimer.set_one_shot(false)
	add_child(RandomObjectSpawnTimer)
	RandomObjectSpawnTimer.start(5)
	birdSpawner.connect("collide",lose)

func _on_ground_body_entered(body):
	if body == characterNode:
		gamePlaying = false
		$Scrolling.stopGame()
		$ScrollingClouds.setScrollSpeed(0)
		characterNode.stopGame()
		winlmaoScreen.visible=true
		winlmaoScreen.play()
		
func triggerRandomObjectSpawnTick():
	print("trigger object")
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


func _on_dead_screen_dead():
	emit_signal("dead")
