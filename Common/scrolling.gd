class_name Scrolling
extends Node2D


@export var speed : int = 1000
@export var PlayerScene : Node2D

var active = false

signal scrollDistanceDone


func _ready():
	GameState.stateChanged.connect(
		func(to: GameState.STATE):
			match to:
				GameState.STATE.PLAYING:
					active = true
				GameState.STATE.STOPPED:
					active = false
	)

func _physics_process(delta):
	if active:
		self.position -= Vector2(1.5*delta*speed,delta*speed/1.5)


func scrollAlongDistance(distanceXY):
	print("They see me scrolling, they hating")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + distanceXY, 1)
	tween.tween_property(PlayerScene, "seedPos", PlayerScene.seedPos + distanceXY, 1)
	tween.finished.connect(func(): scrollDistanceDone.emit())
	tween.play()
	
#	position += distanceXY
#	PlayerScene.seedPos += distanceXY
#	scrollDistanceDone.emit()


func stopGame():
	active=false
