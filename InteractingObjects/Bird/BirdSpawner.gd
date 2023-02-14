extends Node2D

var screenOffset : Vector2

@onready var src = $src as Marker2D
@onready var target = $target as Marker2D
@onready var bird = $Bird

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
# TODO laat zen koppeke nekeer piepen voordat hem afkomt
# ik zou da met animation tree doen of procedural met code
# mss is procedural gemakkeijkerek

func _ready():
	screenOffset.x = ProjectSettings.get("display/window/size/viewport_width") / 2
	screenOffset.y = ProjectSettings.get("display/window/size/viewport_height") / 2
	
	vliegVogeltjeVlieg()

func vliegVogeltjeVlieg():
	bird.stopVogelken()
	getFirstPoint()
	getSecondPoint()
#	print(EDGE.keys()[sourceEdge], sourcePos)
#	print(EDGE.keys()[targetEdge], targetPos)
	
	src.position = sourcePos
	target.position = targetPos
	
	bird.position = sourcePos
	bird.showKoppeke()
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	t.connect("timeout", bird.start)

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		vliegVogeltjeVlieg()

func sampleX() -> float:
	return randf_range(-screenOffset.x, screenOffset.x)
	
func sampleY() -> float:
	return randf_range(-screenOffset.y, screenOffset.y)

func randEdge() -> EDGE:
	return EDGE.values().pick_random()
	
func getFirstPoint():
	sourceEdge = randEdge()
	while sourceEdge == EDGE.BOTTOM:
		sourceEdge = randEdge()
	var target = Vector2.ZERO
	sourcePos = pointAlongEdge(sourceEdge)
	
func getSecondPoint():
	targetEdge = randEdge()
	while sourceEdge == targetEdge:
		targetEdge = randEdge()
	targetPos = pointAlongEdge(targetEdge)


func pointAlongEdge(edge: EDGE) -> Vector2:
	var pos := Vector2.ZERO
	match edge:
		EDGE.LEFT:
			pos.x =  -screenOffset.x
			pos.y = sampleY()
			pass
		EDGE.RIGHT:
			pos.x = screenOffset.x
			pos.y = sampleY()
			pass
		EDGE.BOTTOM:
			pos.y = screenOffset.y
			pos.x = sampleX()
		EDGE.TOP:
			pos.y = -screenOffset.y
			pos.x = sampleX()
	return pos

func _on_bird_collide():
	emit_signal("collide")
