extends CharacterBody2D


@export var speed = 50.0
@export var sourcePos : Marker2D 
@export var targetPos : Marker2D

@onready var sprite = $BirbPlaceholder

var isFlying = false
var isPeaking = false
var direction: Vector2 = Vector2.ZERO

@export var startsOnEdge : BirdSpawner.EDGE

signal collide

const animationMovementAmount = 16

func start():
	$AnimationPlayer.play("koppeke")

func _ready():
	assert(sourcePos != null, "loempen uil")
	assert(targetPos != null, "loempen uil x2")


func init(pos: Vector2, atEdge: BirdSpawner.EDGE):
	self.startsOnEdge = atEdge
	self.position = pos
	rotation_degrees = 0
	# Correction for the animation to let bird be just off screen
	match self.startsOnEdge:
		BirdSpawner.EDGE.LEFT:
			sprite.flip_h = true
			position.x -= $BackMarker.position.x
		BirdSpawner.EDGE.RIGHT:
			sprite.flip_h = false
			position.x += $BackMarker.position.x
		BirdSpawner.EDGE.TOP:
			rotation_degrees = -90
			position.y += $FrontMarker.position.x
		BirdSpawner.EDGE.BOTTOM:
			rotation_degrees = 90
			position.y -= $BackMarker.position.x

func fly():
	direction = (targetPos.position - sourcePos.position).normalized()
	sprite.flip_h = direction.x > 0
	rotation_degrees = 0
	isFlying = true
#	$kahkaa.play()
	$Tsjirpke2.play()

func _physics_process(delta):
	# if Input.is_action_just_pressed("ui_accept"): #just vr te testen
	#	isFlying = true
	if isFlying:
		velocity = direction * speed * delta
		var collision = move_and_collide(velocity)
		if collision and collision.get_collider().is_in_group("Player"):
			emit_signal("collide")
			$CollisionShape2D.disabled = true
	if isPeaking:
		pass

func stopVogelken():
	isFlying = false


func move_pixel_forward():
	match startsOnEdge:
		BirdSpawner.EDGE.LEFT:
			position.x += animationMovementAmount
		BirdSpawner.EDGE.RIGHT:
			position.x -= animationMovementAmount
		BirdSpawner.EDGE.TOP:
			position.y += animationMovementAmount
		BirdSpawner.EDGE.BOTTOM:
			position.y -= animationMovementAmount

func move_pixel_backward():
	match startsOnEdge:
		BirdSpawner.EDGE.LEFT:
			position.x -= animationMovementAmount
		BirdSpawner.EDGE.RIGHT:
			position.x += animationMovementAmount
		BirdSpawner.EDGE.TOP:
			position.y -= animationMovementAmount
		BirdSpawner.EDGE.BOTTOM:
			position.y += animationMovementAmount

func showKoppeke():
#	var p1 = Vector2(sourcePos.position.x, sourcePos.position.y)
	var p2 = Vector2(targetPos.position.x, targetPos.position.y)
	direction = (targetPos.position - sourcePos.position).normalized()
	sprite.flip_h = direction.x > 0
	position.move_toward(p2, 2)
	

func _on_animation_player_animation_finished(_anim_name):
	sprite.frame = randi_range(0,1)
	fly()
