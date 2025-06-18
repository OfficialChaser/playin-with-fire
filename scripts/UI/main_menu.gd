extends Control

const MAIN = preload("res://scenes/main.tscn")

# Main menu nodes
@onready var title_sprite = $TitleSprite
@onready var buttons = $Buttons
@onready var play_button = $Buttons/PlayButton

# Settings nodes
@onready var settings_menu: Control = $SettingsMenu


var in_settings = false


func _ready():
	MusicManager.play_music("menu_music")
	enable_settings(false)
	if GameManager.game_loaded:
		Transition.play("fade_out")
	GameManager.game_loaded = true

func _process(_delta):
	# Could delete this if you keep track of game state
	if InputManager.using_controller:
		InputManager.handle_controller_ui_navigation()

func enable_settings(enabled : bool):
	# Update what UI is showing
	in_settings = enabled
	settings_menu.visible = enabled
	buttons.visible = !enabled
	title_sprite.visible = !enabled
	
	if enabled:
		settings_menu.grab_menu_button_focus()
	else:
		play_button.grab_focus()


func _on_play_button_pressed():
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	MusicManager.play_music("game_music")
	get_tree().change_scene_to_packed(MAIN)

func _on_settings_button_pressed():
	enable_settings(true)
