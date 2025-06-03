extends Area2D

# Speed + Velocity vars
@export var speed := 300
var velocity := Vector2.ZERO

# Damage vars
@export var starting_damage := 20
@export var damage_decay_rate := 30.0
var damage := 20.0

# Appearance + Lifetime vars
@export var opacity_decay_rate := 1.0
@export var lifetime := 1.0

# Onreadys
@onready var sprite_2d = $Sprite2D


func _ready():
	damage = starting_damage
	velocity = Vector2.RIGHT.rotated(rotation + deg_to_rad(randf_range(-10, 10))) * speed
	
	# Delete the drop if it goes its whole lifetime without colliding with anything
	await get_tree().create_timer(lifetime).timeout
	queue_free() # Just queuing free for now

func _physics_process(delta):
	global_position += velocity * delta
	manage_decay(delta)

# As water travels further, it becomes less visible and does less damage
func manage_decay(delta):
	sprite_2d.modulate.a -= opacity_decay_rate * delta
	damage -= damage_decay_rate * delta
	damage = clamp(damage, 1, starting_damage)

func _on_body_entered(body):
	if body.name == "FireTiles":
		var tiles = body as TileMapLayer
		
		# Get coordinate of collision
		var coords = tiles.local_to_map(tiles.to_local(global_position))
		
		# Splash damage: check the neighboring 8 squares around the tile
		# Just checking the tile at just the point of collision will give the wrong tile
		# most of the time
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				var cell_coord = coords + Vector2i(x, y)
				
				# If the cell is empty or has no data, skip over it
				if tiles.get_cell_source_id(cell_coord) == -1 or !tiles.get_cell_tile_data(cell_coord):
					continue
				
				# If it is a fire tile, add the damage to it
				if tiles.get_cell_tile_data(cell_coord).get_custom_data("fire"):
					tiles.update_cell_health(cell_coord, damage)
				
				# End sequence for water drop (right now just queue free)
				queue_free()
	elif body.name == "MidgroundTiles":
		queue_free()
