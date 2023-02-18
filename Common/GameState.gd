extends Node


enum STATE {
	PLAYING,
	STOPPED,
	PAUSED
}

@onready
var current_state = STATE.STOPPED

signal stateChanged(to: STATE)

## DOE DEZE FUNCTIE VOOR U SCENE TE DEBUGGEN
func DEBUG_PLS(play_after=.05):
	get_tree().create_timer(play_after).timeout.connect(
		func(): stateChanged.emit(STATE.PLAYING)
	)

func change(to: STATE):
	current_state = to
	stateChanged.emit(to)
	
