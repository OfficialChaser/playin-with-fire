extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var water_particles = $WaterParticles


var stream_length := 0.0
var max_stream_length := 500.0
var half_width = 5

func update_stream():
	stream_length = lerp(stream_length, max_stream_length, 0.03)
	collision_shape_2d.shape.size.x = stream_length
	collision_shape_2d.position.x = stream_length / 2
	water_particles.lifetime = stream_length / 100

func turn_off():
	stream_length = 0.0
	collision_shape_2d.shape.size.x = 0
	collision_shape_2d.position.x = 0

# This is not working right now
# You could switch back to a raycast if you wanted
# But try to make it scale
# I used an area 2d for now
func _on_area_entered(area):
	print("test")
	if area.is_in_group("fire"):
		await get_tree().create_timer(collision_shape_2d.shape.size.x / water_particles.speed_scale / 100).timeout
		area.queue_free()
