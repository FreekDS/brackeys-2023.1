extends Node2D

@onready var characterNode=$Pinda
@onready var RandomObjectSpawnHandler= load("res://randomObjectSpawnHandler.gd").new()
#Use seperate timer to handle random objects, as we want this to be based om actual time and not any physics process/framerate
#Counting the delta would also work, but I prefer this
var RandomObjectSpawnTimer = null


func _ready():
	RandomObjectSpawnTimer=Timer.new()
	RandomObjectSpawnTimer.connect("timeout", triggerRandomObjectSpawnTick)
	RandomObjectSpawnTimer.set_one_shot(false)
	add_child(RandomObjectSpawnTimer)
	RandomObjectSpawnTimer.start(1.0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ground_body_entered(body):
	if(body==characterNode):
		$Scrolling.stopGame()
		$Pinda.stopGame()

func triggerRandomObjectSpawnTick():
	print("tick")
	RandomObjectSpawnHandler.tick()
