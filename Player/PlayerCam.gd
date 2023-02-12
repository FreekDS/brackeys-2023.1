extends Camera2D

#var tween =null
#@onready var Character  = get_parent()

func _ready():
	pass
#	tween=create_tween()
#	tween.set_trans(Tween.TRANS_LINEAR)
#	tween.set_ease(Tween.EASE_OUT)
	

func _process(_delta):
	pass
#	var gvalx = Character.global_position.x
#	var gvaly = Character.global_position.y
#	if(tween.is_valid() && !tween.is_running()):
#		var temp=tween.tween_property(self, "global_position", 
#			Vector2(gvalx,gvaly), 
#			10
#		)
#		if(temp != null):
#			temp.from(global_position)
