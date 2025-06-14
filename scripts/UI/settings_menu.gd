extends Control

var menu : Control
@onready var menu_button = $MarginContainer/VBoxContainer/MenuButton

func _ready():
	menu = get_tree().get_first_node_in_group("main_menu")

func _on_menu_button_pressed():
	menu.enable_settings(false)

func grab_menu_button_focus():
	menu_button.grab_focus()
