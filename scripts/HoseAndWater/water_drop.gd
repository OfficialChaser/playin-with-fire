extends Area2D

# Speed + Velocity vars
@export var speed := 300
var velocity := Vector2.ZERO

# Damage vars
@export var starting_damage := 15
@export var damage_decay_rate := 30.0
var damage := 20.0

# Appearance + Lifetime vars
@export var opacity_decay_rate := 1.0
@export var lifetime := 1.5

# Onreadys
@onready var sprite_2d = $Sprite2D
var fire_tiles

func _ready():
	modulate = GameManager.water_color
	damage = starting_damage
	velocity = Vector2.RIGHT.rotated(rotation + deg_to_rad(randf_range(-1, 1) * GameManager.spread)) * speed
	
	# PREWARM: Touch tile data so HTML5 loads it early - this still doesnt really work exactly right
	fire_tiles = get_node("/root/Main/FireTiles")
	var test_data = fire_tiles.get_cell_tile_data(Vector2i(0, 0))
	if test_data:
		var _i = test_data.get_custom_data("fire")

	# Start decay countdown
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	global_position += velocity * delta
	manage_decay(delta)

# As water travels further, it becomes less visible and does less damage
func manage_decay(delta):
	# Damage should go from starting_damage to 1.0 over `lifetime` seconds
	var damage_decay_per_second = (starting_damage - 1.0) / lifetime
	damage -= damage_decay_per_second * delta
	damage = clamp(damage, 1.0, starting_damage)

	# Opacity should go from 1.0 to 0.0 over `lifetime` seconds
	var opacity_decay_per_second = 1.0 / lifetime
	sprite_2d.modulate.a -= opacity_decay_per_second * delta
	sprite_2d.modulate.a = clamp(sprite_2d.modulate.a, 0.0, 1.0)

func _on_body_entered(body):
	if body == fire_tiles:
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
				if GameManager.player_health <= float(GameManager.max_hp) / 2:
					damage *= 2
				if tiles.get_cell_tile_data(cell_coord).get_custom_data("fire"):
					tiles.update_cell_health(cell_coord, damage)
				
		# End sequence for water drop (right now just queue free)
		queue_free()
	elif body.name == "MidgroundTiles":
		queue_free()
