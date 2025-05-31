extends Node2D

var spraying : bool

@onready var sprite = $Sprite2D

@onready var water_drop = preload("res://scenes/water_drop.tscn")

func _ready():
	pass

func _process(_delta):
	look_at(get_global_mouse_position())
	
	if spraying:
		spawn_water_drop()

## Turn spraying on or off depending on the parameteras
func spray(status: bool = true):
	spraying = status

func spawn_water_drop():
	var drop = water_drop.instantiate()
	drop.global_position = sprite.global_position
	drop.rotation = sprite.global_rotation
	get_tree().current_scene.add_child(drop)
