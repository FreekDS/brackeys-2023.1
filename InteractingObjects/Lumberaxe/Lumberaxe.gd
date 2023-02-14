extends CharacterBody2D

@export var throwSpeed = 50;

@export var Start : Marker2D
@export var End : Marker2D

# Put interpolation point 100 above the player, can be randomized 
var offsetPlayerY = -100

var playerTargetPosition
var t = 0
var throwing = false

signal throw_completed

# vrij dom om het zo te doen ma het zou wel kunenn werken :)
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, time: float):
	var q0 = p0.lerp(p1, time)
	var q1 = p1.lerp(p2, time)
	var r = q0.lerp(q1, time)
	return r

func playerWithOffset() -> Vector2:
	return playerTargetPosition + Vector2(0, offsetPlayerY)

func _physics_process(delta):
	if throwing:
		t += delta/60 *  throwSpeed
		position = _quadratic_bezier(Start.position, playerWithOffset(), End.position, t)
		$Sprite2D.rotation_degrees += 10
		if position.y > End.position.y + 100:
			throwing = false
			t = 0
			emit_signal("throw_completed")

func throwAtPlayer(player: Vector2) -> void:
	playerTargetPosition = player
	throwing = true
	t = 0
	# randomize offset ?
