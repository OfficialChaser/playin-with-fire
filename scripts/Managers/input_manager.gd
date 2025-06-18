extends Node

## === Signals ===
signal changed_input_method(new_method)

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
	var prev_key_mode = key_mode
	if event is InputEventKey:
		key_mode = detect_key_layout()
		look_mode = InputMode.MOUSE
		
	if event is InputEventMouse:
		look_mode = InputMode.MOUSE
		if key_mode == InputMode.CONTROLLER:
			key_mode = InputMode.WASD
		
	if event is InputEventJoypadMotion:
		key_mode = InputMode.CONTROLLER
		look_mode = InputMode.CONTROLLER
	
	# Emit signal on changed input mode
	if prev_key_mode != key_mode:
		print(key_mode)
		changed_input_method.emit(key_mode)

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
	# WASD is the default
	return key_mode

func handle_controller_ui_navigation():
	if not using_controller:
		push_warning("Don't call this function if the input mode isn't controller!")
		
	var focus = get_viewport().gui_get_focus_owner()
	if Input.is_action_just_pressed("spray") and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if focus is CheckBox:
			focus.button_pressed = !focus.button_pressed
			focus.emit_signal("toggled", focus.button_pressed)
		elif focus is Button:
			focus.emit_signal("pressed")

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
