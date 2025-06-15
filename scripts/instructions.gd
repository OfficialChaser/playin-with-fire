extends Node2D

func _ready():
	if GameManager.stats.day == 1:
		visible = true
	else:
		visible = false
