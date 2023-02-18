class_name TimelapseOverlay

extends CanvasLayer

@onready var animations := $AnimationPlayer as AnimationPlayer

signal timelapseStopped

# Call den deze als den boom start met groeien
func start():
	animations.play("Start")

# Call den deze als den boom volgroeid is en de volgende iteratie start
func stop():
	animations.animation_finished.connect(
		func(_lol): timelapseStopped.emit(),
		CONNECT_ONE_SHOT
	)
	animations.play_backwards("Start")
	

# vr te testen
func _input(event):
	if event.is_action_pressed("ui_up"):
		stop()
	if event.is_action_pressed("ui_down"):
		start()

