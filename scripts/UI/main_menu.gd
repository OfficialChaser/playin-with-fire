extends Control

const MAIN = preload("res://scenes/main.tscn")
@onready var settings_menu: Control = $SettingsMenu

func _ready():
	MusicManager.play_music("menu_music")
	$Pwf/AnimationPlayer.play("wiggle")

func _on_button_pressed() -> void:
	Transition.play("fade_in")
	await get_tree().create_timer(1).timeout
	MusicManager.play_music("game_music")
	get_tree().change_scene_to_packed(MAIN)

func _on_button_2_pressed() -> void:
	settings_menu.show()

func _on_back_button_pressed() -> void:
	settings_menu.hide()
