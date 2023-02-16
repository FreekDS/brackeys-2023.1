extends Node2D


@onready var extend=$ArrowExtend
@onready var end=$ArrowEnd

var extendList=[]

var length=100
# Called when the node enters the scene tree for the first time.
func _ready():
	setInitialLength(length)
	
func setInitialLength(newLenght:int):
	length=newLenght
	for i in range(length):
		var newextend=extend.duplicate()
		newextend.position.x=i
		extendList.append(newextend)
		add_child(newextend)
	end.position.x=length
	
func setNewLength(newLenght:int):
	#extend the list if needed(the initial size is large enough this should not be needed, also there is a problem in godot where it sometime fail to create the childs if gone too quickly)
	if(newLenght>extendList.size()):
		for i in range(newLenght-length):
			var newextend=extend.duplicate()
			newextend.position.x=length+i
			extendList.append(newextend)
			add_child(newextend)
	#set the correct extends visible
	for i in range(0, extendList.size()):
		if(i<newLenght):
			extendList[i].visible=true
		else:
			extendList[i].visible=false
	
	length=newLenght
	end.position.x=length
