extends Node

enum InputMode { CONTROLLER, WASD, ARROWS, HJKL, MOUSE }

const WASD = [KEY_A, KEY_D, KEY_W, KEY_S]
const ARROWS = [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]
const HJKL = [KEY_H, KEY_L, KEY_K, KEY_J]

const KEYS = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]]

var key_mode: InputMode = InputMode.WASD

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
