extends HSlider

@export var bus_name: String

var bus_index: int

var starting_bus_db: float

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	starting_bus_db = AudioServer.get_bus_volume_db(bus_index)
	value = 1
	
func _on_value_changed(val: float):
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(val) + starting_bus_db
	)

func _on_mute_toggled(toggled_on: bool):
	AudioServer.set_bus_mute(bus_index,toggled_on)
