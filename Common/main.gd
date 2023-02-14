extends Node2D

@onready var characterNode=$MapleSeed
@onready var dedlmaoScreen= $EndScreen/DeadScreen
@onready var winlmaoScreen= $EndScreen/WinScreen
@onready var birdSpawner= $BirdSpawner
#Use seperate timer to handle random objects, as we want this to be based om actual time and not any physics process/framerate
#Counting the delta would also work, but I prefer this
var RandomObjectSpawnTimer = null
var rng = RandomNumberGenerator.new()

#This variable gets modified by the root node in main.tscn
var difficulty=100

var gamePlaying = true

signal win
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
		characterNode.stopGame()
		winlmaoScreen.visible=true
		winlmaoScreen.play()
		
func triggerRandomObjectSpawnTick():
	print("trigger object")
	rng.randomize()
	var number = rng.randi_range(1,10)
	if(number <= difficulty) and gamePlaying:
		birdSpawner.vliegVogeltjeVlieg()
		
	
func _on_win_screen_win():
	emit_signal("win")
	gamePlaying = true

func lose():
	gamePlaying = false
	$Scrolling.stopGame()
	characterNode.stopGame()
	dedlmaoScreen.visible=true
	dedlmaoScreen.play()
