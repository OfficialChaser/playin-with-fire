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

func _unhandled_input(event):
	if event is InputEventKey:
		key_mode = detect_key_layout()
		look_mode = InputMode.MOUSE
		
	elif event is InputEventJoypadMotion:
		key_mode = InputMode.CONTROLLER
		look_mode = InputMode.CONTROLLER
