extends Node2D

@onready var characterNode=$Pinda
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ground_body_entered(body):
	if(body==characterNode):
		$Scrolling.stopGame()
		$Pinda.stopGame()
