extends TileMapLayer

# Data dictionaries
var fire_health = {}
var fire_areas = {}

# Fire stats
@export var starting_health := 100.0

# Onreadys
@onready var cooldown_timer = $CooldownTimer

# Fire Damge Zone Scene - For body detection, animations, etc
const FIRE_DAMAGE_ZONE = preload("res://scenes/Fire/fire_damage_zone.tscn")
const SMOKE_PARTICLES = preload("res://scenes/Fire/smoke_particles.tscn")

@export var player : Player


func _ready():
	# Give each starting fire cell a health
	for coords in get_used_cells():
		fire_health[coords] = starting_health

func _on_cooldown_timer_timeout():
	add_fire()

func add_fire():
	var coord_pair
	var possible_coord_pairs
	# Make sure the tile chosen is a fire tile
	# If the map is full this will crash
	while true:
		coord_pair = get_used_cells().pick_random()
		possible_coord_pairs = find_open_surrounding_tiles(coord_pair)
		if get_cell_tile_data(coord_pair) and get_cell_tile_data(coord_pair).get_custom_data("fire"):
			if possible_coord_pairs.size() > 0:
				break
				
	var new_coord_pair = possible_coord_pairs.pick_random()
	
	# Vector2i(0, 0) represents the first tile in the tileset (the fire)
	set_cell(new_coord_pair, 0, Vector2i(0, 0))
	fire_health[new_coord_pair] = starting_health
	add_fire_zone_area(new_coord_pair)

func update_cell_health(coord_pair: Vector2i, damage: float):
	# If it isn't a cell with fire health for whatever reason,
	# Skip it
	if !fire_health.has(coord_pair):
		return
	
	# Apply damage
	fire_health[coord_pair] -= damage
	#Spawn smoke
	var smoke = SMOKE_PARTICLES.instantiate()
	smoke.global_position = 16*coord_pair + Vector2i(8,8)
	get_tree().current_scene.add_child(smoke)
	smoke.emitting = true
	
	if fire_health[coord_pair] <= 0:
		# Remove from list
		fire_health.erase(coord_pair)
		# End sequence (right now, just turn the cell off)
		set_cell(coord_pair, -1)
		
		# Remove Fire Area from scene and list
		if fire_areas.has(coord_pair):
			fire_areas[coord_pair].queue_free()
			fire_areas.erase(coord_pair)


func find_open_surrounding_tiles(coord_pair: Vector2i):
	var possible_coord_pairs = []
	
	# Check surrounding 8 tiles
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var cell_coord_pair = coord_pair + Vector2i(x, y)

			# If the tile is open, add it to the list
			var distance_to_player =  cell_coord_pair.distance_to(player.global_position)
			if get_cell_tile_data(cell_coord_pair) == null and distance_to_player > 4:
				possible_coord_pairs.append(cell_coord_pair)
	
	return possible_coord_pairs


func add_fire_zone_area(coords: Vector2i):
	var new_fire_area : Area2D = FIRE_DAMAGE_ZONE.instantiate()
	var offset : Vector2i = Vector2i(8,8)
	fire_areas[coords] = new_fire_area
	new_fire_area.position = coords*16 + offset
	get_tree().current_scene.add_child(new_fire_area)
