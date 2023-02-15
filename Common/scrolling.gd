extends Node2D


@export var speed : int = 100

var active = true


func _physics_process(delta):
	if active:
		self.position=self.position-Vector2(delta*speed,delta*speed)
		

func stopGame():
	active=false
