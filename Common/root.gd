extends Node2D
var difficulty =0
#round and difficulty split to have the aging of the lumberjack be different currently not used
var round =0
var gameplay=preload("res://Gameplay.tscn")
var currentMain=null
var started=false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Toremove/Seed.pause()
	
func startGame():
	currentMain=gameplay.instantiate()
	add_child(currentMain)
	currentMain.connect("win",_on_main_win)
	currentMain.connect("dead",restart)
	
func _on_main_win():
	difficulty+=1
	round+=1
	remove_child(currentMain)
	currentMain=gameplay.instantiate()
	add_child(currentMain)
	currentMain.connect("win",_on_main_win)
	currentMain.connect("dead",restart)
	currentMain.difficulty=difficulty

func restart():
	get_tree().reload_current_scene()
	
func removeAndStart():
	remove_child($Toremove)
	$Menu.visible=false
	startGame()
	
func _on_button_pressed():	
	if !started:
		started=true
		$Toremove/ZoomCamera.zoomToSeed($Toremove/Seed.position)
		var timer=Timer.new()
		timer.connect("timeout", removeAndStart)
		timer.set_one_shot(true)
		add_child(timer)
		timer.start(3)

