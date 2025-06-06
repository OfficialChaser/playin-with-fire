extends Control

var change = 0

func _ready():
	change = 0
	visible = false

func _on_master_volume_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	value = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index,value)


func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)


func _on_music_volume_value_changed(value: float) -> void:
	value = linear_to_db(value)
	AudioServer.set_bus_volume_db(1,value)

func _on_check_box_2_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1,toggled_on)


func _on_sfx_volume_value_changed(value: float) -> void:
	value = linear_to_db(value)
	var old_db = AudioServer.get_bus_volume_db(2)
	AudioServer.set_bus_volume_db(2,value)
	playRngSfx(value - old_db)
		

func playRngSfx(unc):
	if  $SFX0.playing or $SFX1.playing or $SFX2.playing or $SFX3.playing: #or abs(change) < GameManager.slider_sound_skip:
		change += unc
		print_debug(change)
	else:
		var sound = randi_range(0,3)
		change = 0
		if sound == 0:
			$SFX0.play()
		elif sound == 1:
			$SFX1.play()
		if sound == 2:
			$SFX2.play()
		else:
			$SFX3.play()


func _on_check_box_3_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2,toggled_on)


func _on_button_pressed() -> void:
	hide()
	get_parent().show_buttons()
