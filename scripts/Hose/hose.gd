extends Node2D

var spraying : bool

@onready var sprite = $Sprite2D
@onready var hose_stream = $HoseStream
@onready var water_particles = $HoseStream/WaterParticles

func _ready():
	pass

func _process(_delta):
	look_at(get_global_mouse_position())
	
	if not spraying:
		hose_stream.turn_off()
		return
	
	hose_stream.update_stream()

## Turn spraying on or off depending on the parameter
func spray(status: bool = true):
	spraying = status
	water_particles.emitting = status
