class_name Bird
extends CharacterBody2D


@export var speed = 50.0
@export var sourcePos : Vector2 = Vector2.ZERO
@export var targetPos : Vector2 = Vector2.ZERO

@onready var sprite = $BirbPlaceholder
@onready var particle = $Particles/GPUParticles2D
var isFlying = false
var isPeaking = false
var direction: Vector2 = Vector2.ZERO

@export var startsOnEdge : BirdSpawner.EDGE

signal collide

const animationMovementAmount = 16

func start():
	particle.emitting = true
	direction = (targetPos - sourcePos).normalized()
	particle.process_material.set("direction", direction * speed)
	particle.process_material.set("gravity", direction * speed)
	$AnimationPlayer.play("koppeke")

func _ready():
	randomizePitch()


func init(pos: Vector2, target: Vector2, atEdge: BirdSpawner.EDGE):
	self.startsOnEdge = atEdge
	self.position = pos
	self.sourcePos = pos
	self.targetPos = target
	sprite.rotation_degrees = 0
	# Correction for the animation to let bird be just off screen
	match self.startsOnEdge:
		BirdSpawner.EDGE.LEFT:
			sprite.flip_h = true
			position.x -= $BackMarker.position.x
		BirdSpawner.EDGE.RIGHT:
			sprite.flip_h = false
			position.x += $BackMarker.position.x
		BirdSpawner.EDGE.TOP:
			sprite.rotation_degrees = -90
			position.y += $FrontMarker.position.x
		BirdSpawner.EDGE.BOTTOM:
			sprite.rotation_degrees = 90
			position.y -= $BackMarker.position.x

func fly():
	direction = (targetPos - sourcePos).normalized()
	sprite.flip_h = direction.x > 0
	sprite.rotation_degrees = 0
	isFlying = true

#	$kahkaa.play()
	$Tsjirpke2.play()
	$DespawnTimer.start()

func _physics_process(delta):
	# if Input.is_action_just_pressed("ui_accept"): #just vr te testen
	#	isFlying = true
	if isFlying:
		velocity = direction * speed * delta
		var collision = move_and_collide(velocity)
		if collision and collision.get_collider().is_in_group("Player"):
			emit_signal("collide")
			$CollisionShape2D.disabled = true

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
	var direction = Vector3(targetPos.x,targetPos.y,0)
	particle.process_material.set("direction", direction)
	#particle.process_material.set("gravity", direction)
	var p2 = Vector2(targetPos.x, targetPos.y)
	direction = (targetPos - sourcePos).normalized()
	sprite.flip_h = direction.x > 0
	position.move_toward(p2, 2)

func randomizePitch():
	var pitch = randf_range(0.7, 1.2)
	$Tsjirpke.pitch_scale = pitch
	$Tsjirpke2.pitch_scale = pitch
	

func _on_animation_player_animation_finished(_anim_name):
	sprite.frame = randi_range(0,1)
	particle.emitting = false
	fly()


func _on_despawn_timer_timeout():
	queue_free()
