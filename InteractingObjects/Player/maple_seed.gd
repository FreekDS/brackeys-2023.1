extends CharacterBody2D


@export var moveSpeed = 300
@export var dashSpeed = 600

@onready var arrow=$Arrow

var enabled = true

var margin = Vector2(25, 10)

var marginx = 25
var marginy = 10

var intersectCircleSize=75
var maxArrowSize=40

var startDrag=null
var isDragging=false
var currentArrowPower=0
var additionalPowerMult=4

var velocityAttrition=0.99


func _process(_delta):
	if(isDragging):
		focusArrow()

func _input(event):
	if(enabled):
		if event.is_action_pressed("mouse_down") and not isDragging:
			isDragging=true
			startDrag=get_global_mouse_position()
			arrow.visible=true
		if event.is_action_released("mouse_down"):
			var mousePosNomalized = get_global_mouse_position().normalized()
			velocity.x = -currentArrowPower*mousePosNomalized.x*additionalPowerMult
			velocity.y = -currentArrowPower*mousePosNomalized.y*additionalPowerMult
			isDragging=false
			arrow.visible=false

func focusArrow():
	var mousePos = get_global_mouse_position()
	
	var magnitude=sqrt(mousePos.x*mousePos.x+mousePos.y*mousePos.y)
	var arrowpos=Vector2((mousePos.x/magnitude)*intersectCircleSize,(mousePos.y/magnitude)*intersectCircleSize)
	arrow.position=arrowpos
	arrow.rotation=(mousePos).angle()
	
	var diff=startDrag-mousePos
	var diffLength=int(sqrt(diff.x*diff.x+diff.y*diff.y))
	currentArrowPower=clamp(4,diffLength/3,maxArrowSize)
	arrow.setNewLength(currentArrowPower)

func _physics_process(_delta):
	if enabled:

		var pos = self.get_global_transform_with_canvas().origin
		#Make velocity go to 0 over time
		velocity=velocity*velocityAttrition
		
		var maximum = get_viewport().get_visible_rect().size
		if  pos.x > (maximum.x - marginx) and velocity.x > 0:
			velocity.x = 0
		if pos.x < marginx and velocity.x < 0:
			velocity.x = 0
		if pos.y > (maximum.y-marginy) and velocity.y > 0:
			velocity.y = 0
		if pos.y < marginy and velocity.y < 0:
			velocity.y = 0
		
		move_and_slide()
		
#		self.rotation_degrees+=delta*1000

func _on_ground_hit():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
	velocity = Vector2.ZERO
	enabled = false

func stopGame():
	velocity = Vector2(0,0)
	enabled = false
