extends Control

const MAIN = preload("res://scenes/main.tscn")
@onready var settings_menu: Control = $SettingsMenu
@onready var pwf: Sprite2D = $Pwf

func _ready():
	MusicManager.play_music("menu_music")
	$Pwf/AnimationPlayer.play("wiggle")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spray") and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		justGo()
		
func justGo():
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	MusicManager.play_music("game_music")
	get_tree().change_scene_to_packed(MAIN)

func _on_button_pressed() -> void:
	justGo()

func _on_button_2_pressed() -> void:
	settings_menu.show()
	$PlayButton.hide()
	$Button2.hide()

func show_buttons():
	$PlayButton.show()
	$Button2.show()
