extends Area2D

@export var speed := 300
@export var lifetime := 1

var velocity := Vector2.ZERO

func _ready():
	velocity = Vector2.RIGHT.rotated(rotation + deg_to_rad(randf_range(-10, 10))) * speed
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	global_position += velocity * delta

func _on_body_entered(body):
	if body is not TileMap:
		return
	var tile_pos = body.local_to_map(global_position)
	var data = body.get_cell_tile_data(0, tile_pos)
	
	if data and data.get_custom_data("fire"):
		body.set_cell(0, tile_pos, -1)
		queue_free()
