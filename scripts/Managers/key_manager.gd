extends Node

const WASD = [KEY_A, KEY_D, KEY_W, KEY_S]
const ARROWS = [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]
const HJKL = [KEY_H, KEY_L, KEY_K, KEY_J]

const KEYS = [["A", "D", "W", "S"], ["←", "→", "↑", "↓"], ["H", "L", "K", "J"]]

func keys_layout():
	if Input.is_physical_key_pressed(WASD[0]) or Input.is_physical_key_pressed(WASD[1]) or Input.is_physical_key_pressed(WASD[2]) or Input.is_physical_key_pressed(WASD[3]):
		return GameManager.InputMode.WASD
	elif Input.is_physical_key_pressed(ARROWS[0]) or Input.is_physical_key_pressed(ARROWS[1]) or Input.is_physical_key_pressed(ARROWS[2]) or Input.is_physical_key_pressed(ARROWS[3]):
		return GameManager.InputMode.ARROWS
	elif Input.is_physical_key_pressed(HJKL[0]) or Input.is_physical_key_pressed(HJKL[1]) or Input.is_physical_key_pressed(HJKL[2]) or Input.is_physical_key_pressed(HJKL[3]):
		return GameManager.InputMode.HJKL
	else: 
		return GameManager.key_mode
