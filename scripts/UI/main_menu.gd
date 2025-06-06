extends Control

const MAIN = preload("res://scenes/main.tscn")
@onready var settings_menu: Control = $SettingsMenu
@onready var pwf: Sprite2D = $Pwf
var settings = false

@onready var masterSlider = $"SettingsMenu/MarginContainer/VBoxContainer/VBoxContainer/Master Volume"
@onready var musicSlider = $"SettingsMenu/MarginContainer/VBoxContainer/VBoxContainer2/Music Volume"
@onready var SFXSlider = $"SettingsMenu/MarginContainer/VBoxContainer/VBoxContainer3/SFX Volume"

@onready var backbtn = $SettingsMenu/MarginContainer/VBoxContainer/Button

@onready var masterBtn = $"SettingsMenu/MarginContainer/VBoxContainer/VBoxContainer/CheckBox"
@onready var musicBtn = $"SettingsMenu/MarginContainer/VBoxContainer/VBoxContainer2/CheckBox2"
@onready var SFXBtn = $"SettingsMenu/MarginContainer/VBoxContainer/VBoxContainer3/CheckBox3"

@onready var playbtn = $PlayButton
@onready var settsbtn = $Button2



func _ready():
	MusicManager.play_music("menu_music")
	$Pwf/AnimationPlayer.play("wiggle")
	setts(false)

func _process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("reroll"):
		setts(!settings)

	var d = 0
	if Input.is_action_pressed("look_right") or Input.is_action_pressed("move_right"):
		d = delta
	elif Input.is_action_pressed("look_left") or Input.is_action_pressed("move_left"):
		d = -delta
	handle_ctrler(
		Input.is_action_just_pressed("spray") and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT), 
		Input.is_action_just_pressed("look_up") or Input.is_action_just_pressed("move_up"), 
		Input.is_action_just_pressed("look_down") or Input.is_action_just_pressed("move_down"), 
		d )

func handle_ctrler(spray, up, down, dir):
	var focus = get_viewport().gui_get_focus_owner()
	if up and focus == backbtn:
		SFXBtn.grab_focus()
	elif down and focus == SFXBtn:
		backbtn.grab_focus()
	if spray:
		if focus == backbtn or focus == settsbtn or focus == playbtn:
			focus.emit_signal("pressed")
		elif focus == masterBtn or focus == musicBtn or focus == SFXBtn:
			focus.button_pressed = !focus.button_pressed
	if focus == masterSlider:
		masterSlider.value += dir
	elif focus == musicSlider:
		musicSlider.value += dir
	elif focus == SFXSlider:
		SFXSlider.value += dir
	
func setts(hej : bool):
	settings = hej
	if hej:
		settings_menu.show()
		playbtn.hide()
		settsbtn.hide()
		masterSlider.grab_focus()
	else:
		settings_menu.hide()
		playbtn.show()
		settsbtn.show()
		playbtn.grab_focus()

func _on_button_pressed() -> void:
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	MusicManager.play_music("game_music")
	get_tree().change_scene_to_packed(MAIN)

func _on_button_2_pressed() -> void:
	setts(true)

func show_buttons():
	setts(false)
