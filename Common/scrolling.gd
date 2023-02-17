extends Node2D


@export var speed : int = 1000

var active = true


func _physics_process(delta):
	if active:
		self.position -= Vector2(1.5*delta*speed,delta*speed/1.5)


func scrollAlongDistance(distanceXY):
	
	pass


func stopGame():
	active=false
