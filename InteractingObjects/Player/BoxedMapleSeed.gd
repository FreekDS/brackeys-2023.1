class_name Player
extends Node2D

@onready var zaad=$MapleSeed
@onready var box1=$KooiLeftUp
@onready var box2=$KooiRightDown


@export var seedPos = Vector2.ZERO : 
	get:
		return zaad.position
	set(value):
		zaad.position = value

signal buried

func _ready():
	GameState.stateChanged.connect(_on_gameState_changed)

func _process(delta):
	zaad.position.x=clamp(box1.position.x,zaad.position.x,box2.position.x)
	zaad.position.y=clamp(box1.position.y,zaad.position.y,box2.position.y)


func _on_gameState_changed(to: GameState.STATE):
	match to:
		GameState.STATE.PLAYING:
			pass
		GameState.STATE.STOPPED:
			stopGame()


func getSeedPos():
	return zaad.position


func playBuryAnimation():
	zaad.playBuryAnimation()


func stopGame():
	zaad.stopGame()


func _on_maple_seed_seed_buried():
	buried.emit()
