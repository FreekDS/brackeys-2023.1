extends CharacterBody2D


@export var moveSpeed = 300
@export var dashSpeed = 600

@onready var arrow=$Arrow

var enabled = false

var margin = Vector2(25, 10)

var marginx = 25
var marginy = 10

var intersectCircleSize=75
var maxArrowSize=40

var isDragging=false
var currentArrowPower=0
var additionalPowerMult=4
var clickMaxDistance=100
var enableArrowAfter=30

var velocityAttrition=0.985

signal seedBuried


func _ready():
	GameState.stateChanged.connect(
		func(to: GameState.STATE):
			match to:
				GameState.STATE.PLAYING:
					$AnimatedSprite2D.play("vlieg")
					enabled = true
				GameState.STATE.STOPPED:
					$AnimatedSprite2D.stop()
	)


func _process(_delta):
	if(isDragging):
		focusArrow()

func _input(event):
	if(enabled):
		if event.is_action_pressed("mouse_down") and not isDragging:
			var startDrag=get_global_mouse_position()
			if(position.distance_to(startDrag)<clickMaxDistance):
				isDragging=true
				
		if event.is_action_released("mouse_down") and isDragging:
			if(arrow.visible):
				var mousePosNomalized = (get_global_mouse_position()-position).normalized()
				velocity.x = -currentArrowPower*mousePosNomalized.x*additionalPowerMult
				velocity.y = -currentArrowPower*mousePosNomalized.y*additionalPowerMult
			isDragging=false
			arrow.visible=false

func focusArrow():
	var mousePos = get_global_mouse_position()
	arrow.visible=position.distance_to(mousePos)>enableArrowAfter
	var difPos=mousePos-position
	var magnitude=sqrt(difPos.x*difPos.x+difPos.y*difPos.y)
	var arrowpos=Vector2((difPos.x/magnitude)*intersectCircleSize,(difPos.y/magnitude)*intersectCircleSize)
	arrow.position=arrowpos
	arrow.rotation=(difPos).angle()
	
	var diff=position-mousePos
	var diffLength=int(sqrt(diff.x*diff.x+diff.y*diff.y))
	currentArrowPower=clamp(4,diffLength/3,maxArrowSize)
	arrow.setNewLength(currentArrowPower)

func _physics_process(_delta):
	if enabled:
		velocity=velocity*velocityAttrition
		move_and_slide()

func stopGame():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
	velocity = Vector2.ZERO
	enabled = false
	
func playBuryAnimation():
	$AnimatedSprite2D.bury_me()
	pass


func _on_animated_sprite_2d_completely_buried():
	seedBuried.emit()
