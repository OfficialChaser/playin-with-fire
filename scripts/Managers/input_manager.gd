extends Node

## === General Enums ===
enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE }

## === Key Lists ===
const WASD = [KEY_A, KEY_D, KEY_W, KEY_S]
const ARROWS = [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]
const HJKL = [KEY_H, KEY_L, KEY_K, KEY_J]

# String version
const KEYS = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]]

## === Checker Variables ===
var using_kbm: bool:
	get:
		return look_mode == InputMode.MOUSE
var using_controller: bool:
	get:
		return look_mode == InputMode.CONTROLLER

## === Input Modes ===
var key_mode: InputMode = InputMode.WASD
var look_mode: InputMode = InputMode.MOUSE

## === Controller Variables ===
var last_controller_look_direction: Vector2 = Vector2.RIGHT

func _input(event):
	if event is InputEventKey or event is InputEventMouse:
		key_mode = detect_key_layout()
		look_mode = InputMode.MOUSE
		
	elif event is InputEventJoypadMotion:
		key_mode = InputMode.CONTROLLER
		look_mode = InputMode.CONTROLLER

func detect_key_layout() -> InputMode:
	for key in WASD:
		if Input.is_physical_key_pressed(key):
			return InputMode.WASD
	for key in ARROWS:
		if Input.is_physical_key_pressed(key):
			return InputMode.ARROWS
	for key in HJKL:
		if Input.is_physical_key_pressed(key):
			return InputMode.HJKL
	return key_mode

func get_controller_look_direction() -> Vector2:
	if not using_controller:
		push_warning("Don't call this function if the input mode isn't controller!")
		return Vector2.ZERO
		
	var new_look_direction = Vector2(
		Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
		Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	).normalized()
	
	if new_look_direction.length_squared() > 0.01:
		last_controller_look_direction = new_look_direction
	
	return last_controller_look_direction
