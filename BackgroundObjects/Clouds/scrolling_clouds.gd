extends CanvasLayer


@export var scrollingSpeedMultiplier = .1
@export var direction = Vector2.ZERO

func _ready():
	GameState.stateChanged.connect(
		func(to: GameState.STATE):
			match to:
				GameState.STATE.PLAYING:
					$TextureRect.material.set_shader_parameter("speedMultiplier", scrollingSpeedMultiplier)
					pass
				GameState.STATE.STOPPED:
					$TextureRect.material.set_shader_parameter("speedMultiplier", 0)
					pass
	)

func setScrollSpeed(speedMultiplier):
	scrollingSpeedMultiplier = 0
