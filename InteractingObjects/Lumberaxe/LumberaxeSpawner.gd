extends Node2D

@export var player : Node2D

var nextTargets = []

var active=true
signal collide

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		startThrowAtPlayer()

func startThrowAtPlayer():
	$ExclamationMark.visible = true
	var exclamationTimer = Timer.new()
	exclamationTimer.connect("timeout", exclamationMark)
	exclamationTimer.set_one_shot(true)
	add_child(exclamationTimer)
	exclamationTimer.start(2)
	# On scream end, start throw

func exclamationMark():
	$ExclamationMark.visible = false
	$Lumberaxe.visible=true
	$Lumberaxe.throwAtPlayer(player.seedPos + Vector2(0, randf_range(-100, 100)))

func playDeadAnimation():
	var movepos=Vector2($Lumberaxe.position.x+100,$Lumberaxe.position.y-150)
	$Zaad.position=movepos
	$Zaad.freeze=false
	$Zaad.visible=true
	$Vleugel.position=movepos
	$Vleugel.freeze=false
	$Vleugel.visible=true
func stop():
	active=false

func _on_lumberaxe_collide():
	if active:
		playDeadAnimation()
		emit_signal("collide")
