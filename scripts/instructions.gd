extends Node2D

func _ready():
	if GameStats.day == 1:
		visible = true
	else:
		visible = false
