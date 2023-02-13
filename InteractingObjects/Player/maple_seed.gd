extends CharacterBody2D

var enabled = true

var marginx = 25
var marginy = 10


func _physics_process(delta):
	if enabled:
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		var pos = self.get_global_transform_with_canvas().origin
		var mousePos = get_viewport().get_mouse_position()
		velocity = pos.direction_to(mousePos) * 300
		
		var diff = abs(pos - mousePos)
		if diff.x < 10:
			velocity.x=0
		if diff.y < 10:
			velocity.y=0
			
		var maximum = get_viewport().get_visible_rect().size
		if  pos.x > (maximum.x-marginx) and velocity.x > 0:
			velocity.x = 0
		if pos.x < marginx and velocity.x < 0:
			velocity.x = 0
		if pos.y > (maximum.y-marginy) and velocity.y > 0:
			velocity.y = 0
		if pos.y < marginy and velocity.y < 0:
			velocity.y = 0
		
		move_and_slide()
		
		self.rotation_degrees+=delta*1000
		
func stopGame():
	velocity = Vector2(0,0)
	enabled = false
