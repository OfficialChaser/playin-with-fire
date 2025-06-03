extends Control

const MAIN = preload("res://scenes/main.tscn")
@onready var settings_menu: Control = $SettingsMenu

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)


func _on_button_2_pressed() -> void:
	settings_menu.show()

func _on_back_button_pressed() -> void:
	settings_menu.hide()
