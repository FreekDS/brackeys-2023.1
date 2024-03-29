extends AnimatedSprite2D

var zig = true
var framesPlayed = 0

const pixelSize = 8
const textureHeight = 8

signal completely_buried

func bury_me():
	stop()
	$BuryAnimationTick.start()

func animationFrame():
	var xDelta = -pixelSize if zig else pixelSize
	zig = !zig
	position.x += xDelta
	position.y += pixelSize
	framesPlayed += 1
	if framesPlayed >= textureHeight:
		$BuryAnimationTick.stop()
		completely_buried.emit()
