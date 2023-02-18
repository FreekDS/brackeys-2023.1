class_name BirdSpawner
extends Node2D

var screenOffset : Vector2

@onready var src = $src as Marker2D
@onready var target = $target as Marker2D
@onready var bird = $Bird

@export var BirdScene := preload("res://InteractingObjects/Bird/Bird.tscn")

enum EDGE {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

var sourceEdge: EDGE
var targetEdge: EDGE


var sourcePos = Vector2.ZERO
var targetPos = Vector2.ZERO

signal collide

var topLeftPoint : Vector2
var bottomRightPoint : Vector2

func _ready():
	topLeftPoint = $src.position
	bottomRightPoint = $target.position
	screenOffset.x = ProjectSettings.get("display/window/size/viewport_width") / 2
	screenOffset.y = ProjectSettings.get("display/window/size/viewport_height") / 2
#	vliegVogeltjeVlieg()


func vliegVogeltjeVlieg():
	getFirstPoint()
	getSecondPoint()
#	print(EDGE.keys()[sourceEdge], sourcePos)
#	print(EDGE.keys()[targetEdge], targetPos)

	# Vogeltje instatieren jaja
	var b : Bird = BirdScene.instantiate()
	b.speed = 1000
	b.collide.connect(_on_bird_collide)
	add_child(b)
	b.init(sourcePos, targetPos, sourceEdge)
	b.start()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		vliegVogeltjeVlieg()

func sampleX(minmaxOffset := Vector2.ZERO) -> float:
	var maxF = screenOffset.x - minmaxOffset.x
	var minF = -screenOffset.x + minmaxOffset.x
	return randf_range(minF, maxF)
	
func sampleY(minmaxOffset := Vector2.ZERO) -> float:
	var maxF = screenOffset.y - minmaxOffset.y
	var minF = -screenOffset.y + minmaxOffset.y
	return randf_range(minF, maxF)

func randEdge() -> EDGE:
	return EDGE.values().pick_random()
	
func getFirstPoint():
	sourceEdge = randEdge()
	while sourceEdge == EDGE.BOTTOM:
		sourceEdge = randEdge()
	sourcePos = pointAlongEdge(sourceEdge, Vector2(80, 40))
	
func getSecondPoint():
	targetEdge = randEdge()
	while sourceEdge == targetEdge:
		targetEdge = randEdge()
	targetPos = pointAlongEdge(targetEdge)
	var middle = (sourcePos + targetPos) / 2.0
	if not isInBox(middle):
		getSecondPoint()

func isInBox(point):
	var xOk = topLeftPoint.x <= point.x and point.x <= bottomRightPoint.x
	var yOk = topLeftPoint.y <= point.y and point.y <= bottomRightPoint.y
	return xOk and yOk


func pointAlongEdge(edge: EDGE, minmaxOffset := Vector2.ZERO) -> Vector2:
	var pos := Vector2.ZERO
	match edge:
		EDGE.LEFT:
			pos.x =  -screenOffset.x
			pos.y = sampleY(minmaxOffset)
			pass
		EDGE.RIGHT:
			pos.x = screenOffset.x
			pos.y = sampleY(minmaxOffset)
			pass
		EDGE.BOTTOM:
			pos.y = screenOffset.y
			pos.x = sampleX(minmaxOffset)
		EDGE.TOP:
			pos.y = -screenOffset.y
			pos.x = sampleX(minmaxOffset)
	return pos

func _on_bird_collide():
	emit_signal("collide")
