class_name VictoryManager
extends Node2D

# de manier waarop ik dit wil laten werken
# 1. is de posiitie op het scherm waar het zaad moet zijn voor animatie te spelen
# 2. plek waar boom moet staan nadat hem gegroeid is
# 3. plek waar nieuw zaad moet staan

# De bedoeling is dat er gescrolld wordt naar die posities en gezien de background beweegt
# zijn de posities hier bedoeld voor de offset van de huidige situatie te berkenen.
# deze node is dan verantwoordelijk voor de nodige objecten te scrollen zodat ze gealineerd
# staan zoals we verwachten

# Best met gebruik te maken van tweens veronderstel ik
# ah btw, ik zou den oude tree despawnen hier pas als eerste stap

# misschien kan er ook een scrollTowards(target) point ofzo gemaakt worden in scrollingObjects
# die dan het tweenen doet?
# en dan connecten met een signal (eg scrollCompleted)

# Ik heb het gevoel da ons project een boeltje aan het worden is :)

# Misschien gaan de posities wel nimeer kloppen van zodra deze node toegevoegd wordt in de scene
# Who knows, mijn eerste testen zeiden van ni

@export var scrollingObjects : Scrolling	# Dees is de Node die alle objecten bevat die scrollen ("scrolling" in main)
@export var playerNode : Player

@onready var timelapseOverlay = $timelapse_overlay as TimelapseOverlay
@onready var desiredSeedLocation = $"DesiredSeedLocation (1)"
@onready var treeAnimations = $AnimationPlayer

func _ready():
	if scrollingObjects != null:
		scrollingObjects.scrollDistanceDone.connect(_on_scroll_complete)
	if playerNode != null:
		playerNode.buried.connect(_on_player_buried)

signal victoryAnimationsCompleted

func start():
	playerNode.stopGame()
	var scrollDistance = desiredSeedLocation.position - playerNode.getSeedPos()
	scrollingObjects.scrollAlongDistance(scrollDistance)


func _on_scroll_complete():
	scrollingObjects.scrollDistanceDone.disconnect(_on_scroll_complete)
	print("Flink gedaan :)")
	get_tree().create_timer(.2).timeout.connect(
		func():
			playerNode.playBuryAnimation()
	)
	
	
func _on_player_buried():
	print("Vlug belt den begrafenisondernemer, hem is begraven")
	
	# start timelapse
	timelapseOverlay.start()
	treeAnimations.play("growtree")


func _on_animation_player_animation_finished(_anim_name):
	timelapseOverlay.stop()
	timelapseOverlay.timelapseStopped.connect(
		func():
			get_tree().create_timer(1).timeout.connect(
				func(): victoryAnimationsCompleted.emit(),
				CONNECT_ONE_SHOT
			),
		CONNECT_ONE_SHOT
	)
