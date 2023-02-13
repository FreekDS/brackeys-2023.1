extends Node2D

@onready var characterNode=$MapleSeed
@onready var dedlmaoScreen= $EndScreen/DeadScreen
@onready var winlmaoScreen= $EndScreen/WinScreen
@onready var RandomObjectSpawnHandler= load("res://randomObjectSpawnHandler.gd").new()
#Use seperate timer to handle random objects, as we want this to be based om actual time and not any physics process/framerate
#Counting the delta would also work, but I prefer this
var RandomObjectSpawnTimer = null

#This variable gets modified by the root node in main.tscn
var difficulty=0

signal win
func _ready():
	RandomObjectSpawnTimer=Timer.new()
	RandomObjectSpawnTimer.connect("timeout", triggerRandomObjectSpawnTick)
	RandomObjectSpawnTimer.set_one_shot(false)
	add_child(RandomObjectSpawnTimer)
	RandomObjectSpawnTimer.start(1.0)

func _on_ground_body_entered(body):
	if body == characterNode:
		$Scrolling.stopGame()
		characterNode.stopGame()
		winlmaoScreen.visible=true
		winlmaoScreen.play()
		
func triggerRandomObjectSpawnTick():
	print("tick")
	RandomObjectSpawnHandler.tick()

func _on_win_screen_win():
	emit_signal("win")
