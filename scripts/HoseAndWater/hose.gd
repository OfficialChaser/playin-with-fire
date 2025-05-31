extends Node2D

# Spray vars
var spraying := false
var spray_time := 0.0
@export var min_spray_time := 0.05
@export var max_spray_time := 1.0


@export var drops_per_second := 100.0
var spawn_interval := 1.0 / drops_per_second
var spawn_accumulator := 0.0

# Onreadys
@onready var sprite = $Sprite2D
@onready var water_drop = preload("res://scenes/HoseAndWater/water_drop.tscn")

func _ready():
	pass

func _process(delta):
	look_at(get_global_mouse_position())

	manage_water_spawning(spraying, delta)
	
	spray_time = clamp(spray_time, min_spray_time, max_spray_time)

## Turn spraying on or off depending on the parameteras
func spray(status: bool = true):
	spraying = status

func manage_water_spawning(_spraying: bool, delta: float):
	if _spraying:
		spray_time += delta
		spawn_accumulator += delta

		while spawn_accumulator >= spawn_interval:
			spawn_water_drop()
			spawn_accumulator -= spawn_interval
	else:
		spawn_accumulator = 0.0
		spray_time = min_spray_time
	

## Instantiate water drop to scene
func spawn_water_drop():
	var drop = water_drop.instantiate()
	drop.global_position = $Muzzle.global_position
	drop.rotation = sprite.global_rotation
	drop.lifetime = spray_time
	get_tree().current_scene.add_child(drop)
