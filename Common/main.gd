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
var birdSpawnTimer = null
var axeSpawnTimer = null

#This variable gets modified by the root node in main.tscn

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
	lumberaxeSpawner.connect("collide",lose)
	victoryManager.victoryAnimationsCompleted.connect(
		func(): win.emit()
	)
	
	
	birdSpawnTimer=Timer.new()
	birdSpawnTimer.connect("timeout", triggerBirdSpawn)
	birdSpawnTimer.set_one_shot(false)
	add_child(birdSpawnTimer)
	
	axeSpawnTimer=Timer.new()
	axeSpawnTimer.connect("timeout", triggerAxeSpawn)
	axeSpawnTimer.set_one_shot(false)
	add_child(axeSpawnTimer)
	
	

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
		
		birdSpawnTimer.stop()
		axeSpawnTimer.stop()
		
		$BirdSpawner.stop()
		$LumberaxeSpawner.stop()
#		emit_signal("win")
#		winlmaoScreen.visible=true
#		winlmaoScreen.play()
		
func triggerRandomObjectSpawnTick():
#	print("trigger")
	#Blijkt dat ge niet wilt dat axe en bird hetzelfde random nummer gebruikt, want dan komen ze alt tegelijk
	rng.randomize()
	var numberBird = rng.randi_range(0,100)
	rng.randomize()
	var numberAxe = rng.randi_range(0,100)
	
	#Level  is birds only (at increased rate), level 2 is axe only (at increased rate), from then it is both at gradually increasing ods
	var birdChance=0
	if difficultyLevel==1:
		birdChance=10
	if difficultyLevel>2:
		birdChance=5+((difficultyLevel-3)*5)
		
		
	var axeChance=0
	if difficultyLevel==2:
		axeChance=10
	if difficultyLevel>2:
		axeChance=5+((difficultyLevel-3)*5)
		
	if numberBird<birdChance and gamePlaying:
		birdSpawner.vliegVogeltjeVlieg()
	##Only do axes from level 2
	if numberAxe<axeChance and gamePlaying:	
		lumberaxeSpawner.startThrowAtPlayer()


func triggerBirdSpawn():
	rng.randomize()
	var dupplicate = rng.randi_range(0,100)
	var count=1
	if dupplicate < difficultyLevel*3:
		rng.randomize()
		count = rng.randi_range(1,3)
		
	for i in range(0, count):
		birdSpawner.vliegVogeltjeVlieg()
	
func triggerAxeSpawn():
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
	#RandomObjectSpawnTimer.start(1)
	print("restart?")
	birdSpawnTimer.start(30/(3+difficultyLevel))
	if difficultyLevel >= 3:
		axeSpawnTimer.start(40/(2+difficultyLevel))
#	$Clouds.visible = true
#	$ScrollingClods.visible = true
	
#used to hide the player node on death (where another animation will be played)
func hidePlayer():
	$MapleSeed.visible=false
	
func hitTree():
	$Scrolling/Tree.hitMe()
	
func setNextGradient(texture):
	$Scrolling/CanvasLayer/NextGradient.texture = texture

func setCurrentGradient(texture):
	$Scrolling/CanvasLayer/Gradient.texture = texture
