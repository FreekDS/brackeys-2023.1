extends Node2D


@export var speed : int = 100

var active = true


func _physics_process(delta):
	if active:
		self.position=self.position-Vector2(2*delta*speed,delta*speed/2)
		

func stopGame():
	active=false
