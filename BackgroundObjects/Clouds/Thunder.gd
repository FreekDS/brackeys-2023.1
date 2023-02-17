extends CanvasLayer


# Called when the node enters the scene tree for the first time.
var timerFlits = Timer.new()
var timerOntFlits = Timer.new()

func _ready():
	timerFlits.connect("timeout",flits)
	timerFlits.wait_time = 3
	timerFlits.one_shot = true
	add_child(timerFlits)
	timerFlits.start()
	
	timerOntFlits.connect("timeout",ontflits)
	timerOntFlits.wait_time = 3
	timerOntFlits.one_shot = true
	add_child(timerOntFlits)
	
	
func flits():
	$Flits.visible=true
	var fadeTween=create_tween()	
	fadeTween.tween_property($Flits,"modulate",$Flits.modulate-Color(0,0,0,1),3.0)
	timerOntFlits.start()

func ontflits():
	timerFlits.start()
	$Flits.visible=false
	$Flits.modulate=$Flits.modulate+Color(0,0,0,1)
	
