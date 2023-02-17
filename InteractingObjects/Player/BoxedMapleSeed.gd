extends Node2D

@onready var zaad=$MapleSeed
@onready var box1=$KooiLeftUp
@onready var box2=$KooiRightDown
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	zaad.position.x=clamp(box1.position.x,zaad.position.x,box2.position.x)
	zaad.position.y=clamp(box1.position.y,zaad.position.y,box2.position.y)


func stopGame():
	zaad.stopGame()