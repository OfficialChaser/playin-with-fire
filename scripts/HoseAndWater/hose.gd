extends Node2D

# Constants
const ROTATION_SPEED: float = 7.0

# Spray vars
var spraying := false
var spray_time := 0.0
@export var min_spray_time := 0.05
@export var max_spray_time := 1.0
var drops_spawned := 0

# Spray time stats
var spawn_interval := 1.0 / GameStats.water_spawn_rate
var spawn_accumulator := 0.0

# Controller vars
var last_aim_direction := Vector2.RIGHT

# Onreadys
@onready var sprite = $Sprite2D
@onready var water_drop = preload("res://scenes/HoseAndWater/water_drop.tscn")
var main_camera : MainCamera
var player : Player

# Audio
@onready var hose_sfx = $HoseSFX

func _ready():
	main_camera = get_tree().get_first_node_in_group("main_camera")
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if not GameManager.actively_playing:
		return
	
	handle_hose_rotation(delta)
	manage_water_spawning(delta)
	
	spray_time = clamp(spray_time, min_spray_time, max_spray_time)
	
	spawn_interval = 1.0 / GameStats.water_spawn_rate

func handle_hose_rotation(delta):
	if InputManager.using_controller:
		var target_pos = player.global_position + InputManager.get_controller_look_direction()
		var target_angle = (target_pos - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, 1.0 - exp(-ROTATION_SPEED * delta))
	else:
		rotation = (get_global_mouse_position() - global_position).angle()


func spray(status: bool = true):
	spraying = status
	hose_sfx.playing = status

func manage_water_spawning(delta: float):
	if spraying:
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
	
	if GameStats.blood_enabled:
		drops_spawned += 1
		if drops_spawned > 20:
			GameStats.damage_player(GameStats.player_blood_damage)
			drops_spawned = 0
