extends Control

func _on_master_volume_value_changed(value: float) -> void:
	value = linear_to_db(value)
	AudioServer.set_bus_volume_db(0,value)


func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)


func _on_music_volume_value_changed(value: float) -> void:
	value = linear_to_db(value)
	AudioServer.set_bus_volume_db(1,value)

func _on_check_box_2_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1,toggled_on)


func _on_sfx_volume_value_changed(value: float) -> void:
	value = linear_to_db(value)
	AudioServer.set_bus_volume_db(2,value)


func _on_check_box_3_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2,toggled_on)


func _on_button_pressed() -> void:
	hide()
