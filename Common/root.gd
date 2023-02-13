extends Node2D
var difficulty =0
var gameplay=preload("res://Gameplay.tscn")
var currentMain=null

# Called when the node enters the scene tree for the first time.
func _ready():
	currentMain=gameplay.instantiate()
	add_child(currentMain)
	currentMain.connect("win",_on_main_win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_win():
	difficulty+=1
	remove_child(currentMain)
	currentMain=gameplay.instantiate()
	add_child(currentMain)
	currentMain.connect("win",_on_main_win)
	currentMain.difficulty=difficulty
	
	
