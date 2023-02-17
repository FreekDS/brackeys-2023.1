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

@export var scrollingObjects : Node2D	# Dees is de Node die alle objecten bevat die scrollen ("scrolling" in main)
@export var playerNode : Node2D

@onready var timelapseOverlay = $timelapse_overlay as TimelapseOverlay
