extends CharacterBody2D


@export var speed = 50.0
@export var sourcePos : Marker2D 
@export var targetPos : Marker2D

@onready var sprite = $BirbPlaceholder

var isFlying = false
var isPeaking = false
var direction: Vector2 = Vector2.ZERO

signal collide

func _ready():
	assert(sourcePos != null, "loempen uil")
	assert(targetPos != null, "loempen uil x2")
	
func start():

	direction = (targetPos.position - sourcePos.position).normalized()
	sprite.flip_h = direction.x > 0
	isFlying = true
	$kahkaa.play()

func _physics_process(delta):
	# if Input.is_action_just_pressed("ui_accept"): #just vr te testen
	#	isFlying = true
	if isFlying:	
		velocity = direction * speed * delta
		var collision = move_and_collide(velocity)
		if collision and collision.get_collider().is_in_group("Player"):
			emit_signal("collide")
	if isPeaking:
		pass	
	
	

func stopVogelken():
	isFlying = false


func showKoppeke():
	var p1 = Vector2(sourcePos.position.x, sourcePos.position.y)
	var p2 = Vector2(targetPos.position.x, targetPos.position.y)
	direction = (targetPos.position - sourcePos.position).normalized()
	sprite.flip_h = direction.x > 0
	position.move_toward(p2, 2)
	
	
	

