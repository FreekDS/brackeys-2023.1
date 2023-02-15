extends CanvasLayer

@export var animated = false

@export var timeBetweenMovement = 1.0	#seconds

@onready var cloudRect = $ColorRect
var pixelOffset

var timer : Timer

func _ready():
	pixelOffset = cloudRect.material.get_shader_parameter("pixelSize")
	if animated:
		timer = Timer.new()
		timer.set_one_shot(false)
		timer.timeout.connect(animationTick)
		add_child(timer)
		timer.start(timeBetweenMovement)
		

func animationTick():
	pixelOffset += 4
	var n = cloudRect.material.get_shader_parameter("noise_texture")
	n.noise.offset.x += 4
	cloudRect.material.set_shader_parameter("noise_texture", n)

