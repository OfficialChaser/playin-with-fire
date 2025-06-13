extends Control

const MAIN = preload("res://scenes/main.tscn")

# Main menu nodes
@onready var title_sprite = $TitleSprite
@onready var buttons = $Buttons

# Settings nodes
@onready var settings_menu: Control = $SettingsMenu


var in_settings = false


func _ready():
	MusicManager.play_music("menu_music")
	enable_settings(false)

'''func _process(delta: float) -> void:
	handle_ctrler(
		Input.is_action_just_pressed("spray") and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT), 
		Input.is_action_pressed("look_up") or Input.is_action_pressed("move_up"), 
		Input.is_action_pressed("look_down") or Input.is_action_pressed("move_down"), 
		d )'''

'''func handle_ctrler(spray, _up, _down, dir):
	var focus = get_viewport().gui_get_focus_owner()
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
		SFXSlider.value += dir'''
	
func enable_settings(enabled : bool):
	# Update what UI is showing
	in_settings = enabled
	settings_menu.visible = enabled
	buttons.visible = !enabled
	title_sprite.visible = !enabled
	
	if enabled:
		pass


func _on_play_button_pressed():
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	MusicManager.play_music("game_music")
	get_tree().change_scene_to_packed(MAIN)

func _on_settings_button_pressed():
	enable_settings(true)
