extends Node

const WASD = [KEY_A, KEY_D, KEY_W, KEY_S]
const ARROWS = [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]
const HJKL = [KEY_H, KEY_L, KEY_K, KEY_J]

const KEYS = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]]

func keys_layout() -> GameManager.InputMode:
	for key in WASD:
		if Input.is_physical_key_pressed(key):
			return GameManager.InputMode.WASD
	for key in ARROWS:
		if Input.is_physical_key_pressed(key):
			return GameManager.InputMode.ARROWS
	for key in HJKL:
		if Input.is_physical_key_pressed(key):
			return GameManager.InputMode.HJKL
	return GameManager.stats.key_mode
