extends Camera2D


# Called when the node enters the scene tree for the first time.
func zoomToSeed(location:Vector2):
	var zoomTween=create_tween()
	zoomTween.set_parallel(true)
	zoomTween.tween_property(self,"zoom",self.zoom + Vector2(1.75, 1.75),3.0)
	zoomTween.tween_property(self,"position",location,3.0)
	
