extends Node2D

var active=true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(active):
		self.position=self.position-Vector2(delta*100,delta*100)
func stopGame():
	active=false
