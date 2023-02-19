extends CharacterBody2D

@export var throwSpeed = 20;

@export var Start : Marker2D
@export var End : Marker2D

# Put interpolation point 100 above the player, can be randomized 
var offsetPlayerY = -100

var cameraOffset

var playerTargetPosition
var t = 0
var throwing = false

signal throw_completed
signal collide

# vrij dom om het zo te doen ma het zou wel kunenn werken :)
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, time: float):
	var q0 = p0.lerp(p1, time)
	var q1 = p1.lerp(p2, time)
	var r = q0.lerp(q1, time)
	return r

func playerWithOffset() -> Vector2:
	return playerTargetPosition + Vector2(0, offsetPlayerY)

func _get_viewport_center() -> Vector2:
	var transform : Transform2D = get_viewport_transform()
	var scale : Vector2 = transform.get_scale()
	return -transform.origin / scale + get_viewport_rect().size / scale / 2
	
	
func _physics_process(delta):
	if throwing:
		t += delta/60 *  throwSpeed
		var viewport_rect = get_viewport_rect().size/2
		var center_pos = get_viewport().get_camera_2d().get_screen_center_position()
		var start = center_pos - viewport_rect
		var target = Vector2(playerTargetPosition.x+abs(start.x), playerTargetPosition.y- abs(start.y)/2)
		var end = Vector2(Start.position.x + 2*(target.x-Start.position.x), End.position.y)
		position = _quadratic_bezier(Start.position, target, end, t)
		$Sprite2D.rotation_degrees += 10
		if position.y > End.position.y + 100:
			throwing = false
			$SwingSwangSwung.stop()
			t = 0
			emit_signal("throw_completed")
		var collision = move_and_collide(velocity)
		if collision and collision.get_collider().is_in_group("Player"):
			emit_signal("collide")	
			$CollisionShape2D.disabled = true

func throwAtPlayer(player: Vector2) -> void:
	playerTargetPosition = player
	throwing = true
	$SwingSwangSwung.play()
	t = 0
	# randomize offset ?
