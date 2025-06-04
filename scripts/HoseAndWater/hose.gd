extends Node2D

# Spray vars
var spraying := false
var spray_time := 0.0
@export var min_spray_time := 0.05
@export var max_spray_time := 1.0

# Spray time stats
@export var drops_per_second := 100.0
var spawn_interval := 1.0 / drops_per_second
var spawn_accumulator := 0.0

# KBM + Controller vars
var last_aim_direction: Vector2 = Vector2.RIGHT
enum InputMode { CONTROLLER, MOUSE }
var input_mode = InputMode.MOUSE

# Onreadys
@onready var sprite = $Sprite2D
@onready var water_drop = preload("res://scenes/HoseAndWater/water_drop.tscn")
var main_camera : MainCamera
var player : Player

func _ready():
	main_camera = get_tree().get_first_node_in_group("main_camera")
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if not GameManager.in_game:
		return

	handle_hose_rotation(delta)
	manage_water_spawning(spraying, delta)
	
	spray_time = clamp(spray_time, min_spray_time, max_spray_time)

func _unhandled_input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		input_mode = InputMode.MOUSE
	elif event is InputEventJoypadMotion:
		input_mode = InputMode.CONTROLLER

func handle_hose_rotation(delta):
	var controller = Vector2(
		Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
		Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	).normalized()

	# Track last aim direction and input mode
	if controller.length_squared() > 0.01:
		last_aim_direction = controller
		GameManager.input_mode = GameManager.InputMode.CONTROLLER
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		GameManager.input_mode = GameManager.InputMode.MOUSE

	var target_angle: float

	if input_mode == InputMode.CONTROLLER:
		var target_pos = player.global_position + last_aim_direction
		target_angle = (target_pos - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, 8 * delta)
	else:
		rotation = (get_global_mouse_position() - global_position).angle()

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
