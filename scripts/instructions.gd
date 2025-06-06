extends Node2D

func _ready():
	if GameManager.day == 1:
		visible = true
	else:
		visible = false
