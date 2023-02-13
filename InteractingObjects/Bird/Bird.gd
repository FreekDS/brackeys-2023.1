extends CharacterBody2D


@export var speed = 300.0
@export var sourcePos : Marker2D 
@export var targetPos : Marker2D

@onready var sprite = $BirbPlaceholder

var isFlying = false
var direction: Vector2 = Vector2.ZERO

func _ready():
	assert(sourcePos != null, "loempen uil")
	assert(targetPos != null, "loempen uil x2")
	
func start():
	direction = (targetPos.position - sourcePos.position).normalized()
	sprite.flip_h = direction.x > 0
	isFlying = true
	$kahkaa.play()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"): #just vr te testen
		isFlying = true
	if isFlying:
		velocity = direction * speed * delta
		var collision = move_and_collide(velocity)
		if collision and collision.get_collider().is_in_group("Player"):
			print("jammerlijk")

func showKoppeke():
	# em toont zen koppeke
	
	pass

