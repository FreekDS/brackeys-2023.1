extends CharacterBody2D


@export var speed = 300.0
@export var sourcePos : Marker2D 
@export var targetPos : Marker2D

var isFlying = false
var direction: Vector2 = Vector2.ZERO


func _ready():
	assert(sourcePos != null, "loempen uil")
	assert(targetPos != null, "loempen uil x2")
	direction = (targetPos.position - sourcePos.position).normalized()


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"): #just vr te testen
		isFlying = true
	if isFlying:
		velocity = direction * speed
		move_and_slide()


func showKoppeke():
	# em toont zen koppeke
	
	pass

