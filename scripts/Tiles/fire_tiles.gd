extends TileMapLayer
class_name FireTiles
# Data dictionaries
var fire_health = {}
var fire_areas = {}

# Fire stats
@export var starting_health := 100.0

# Onreadys
@onready var cooldown_timer = $CooldownTimer
@onready var midground_tiles: MidgroundLayer = $"../MidgroundTiles"

# Fire Damge Zone Scene - For body detection, animations, etc
const FIRE_DAMAGE_ZONE = preload("res://scenes/Fire/fire_damage_zone.tscn")
const SMOKE_PARTICLES = preload("res://scenes/Fire/smoke_particles.tscn")

@export var player : Player
@export var gui : GUI


func _ready():
	get_cell_source_id(Vector2i(0, 0))
	fire_areas.clear()
	fire_health.clear()
	
	# If we place any manually
	'''for coords in get_used_cells():
		if get_cell_tile_data(coords).get_custom_data("fire"):
			fire_health[coords] = starting_health
			add_fire_sprite(coords)'''
	
	# None of the tile textures need to be seen
	visible = false
	
	cooldown_timer.wait_time = GameManager.fire_spawn_rate
	
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):

	
	check_house()

func check_house():
	var house_min = Vector2i(-2,-3)
	var house_max = Vector2i(2,1)
	
	for x in range(house_min.x, house_max.x + 1):
		for y in range(house_min.y, house_max.y + 1):
				var house_coord = Vector2i(x, y)
				if fire_areas.has(house_coord):
					GameManager.end_game()
					fire_areas.clear()
					fire_health.clear()

func _on_cooldown_timer_timeout():
	if fire_areas.size() < GameManager.fire_spawn_rate * 10:
		cooldown_timer.wait_time = GameManager.fire_spawn_rate * 10
	elif fire_areas.size() < GameManager.fire_spawn_rate * 30:
		cooldown_timer.wait_time = GameManager.fire_spawn_rate * 4
	elif fire_areas.size() < GameManager.fire_spawn_rate * 50:
		cooldown_timer.wait_time = GameManager.fire_spawn_rate * 2
	else:
		cooldown_timer.wait_time = GameManager.fire_spawn_rate
	if GameManager.in_game:
		add_fire()

func add_fire():
	var possible_coord_pairs = []

	var player_cell = local_to_map(to_local(player.global_position))

	var fire_cells = []
	for cell in get_used_cells():
		if get_cell_tile_data(cell) and get_cell_tile_data(cell).get_custom_data("fire"):
			fire_cells.append(cell)

	fire_cells.shuffle()

	for fire_cell in fire_cells:
		var neighbors = find_open_surrounding_tiles(fire_cell)
		if neighbors.has(player_cell):
			neighbors.erase(player_cell)

		if neighbors.size() > 0:
			possible_coord_pairs = neighbors
			break

	if possible_coord_pairs.size() == 0:
		return
	
	var new_coord_pair = possible_coord_pairs.pick_random()

	if midground_tiles.tree_coverage.has(new_coord_pair):
		var mid_tile_data = midground_tiles.get_cell_tile_data(new_coord_pair)
		if mid_tile_data and !mid_tile_data.get_custom_data('burning'):
			# First time this tree is burning
			mid_tile_data.set_custom_data('burning',true)


	# Vector2i(0, 0) represents the first tile in the tileset (the fire)
	set_cell(new_coord_pair, 0, Vector2i(0, 0))
	fire_health[new_coord_pair] = starting_health
	add_fire_sprite(new_coord_pair)

func update_cell_health(coord_pair: Vector2i, damage: float):
	# If it isn't a cell with fire health for whatever reason,
	# Skip it
	if !fire_health.has(coord_pair):
		return
	
	# Apply damage
	if GameManager.in_game:
		fire_health[coord_pair] -= damage
	
	
	if fire_health[coord_pair] <= 0:
		# Spawn smoke + SFX
		var smoke = SMOKE_PARTICLES.instantiate()
		smoke.global_position = 16*coord_pair + Vector2i(8,8)
		get_tree().current_scene.add_child(smoke)
		smoke.emitting = true
		
		# End sequence (right now, just turn the cell off)
		set_cell(coord_pair, -1)
		
		# Remove Fire Area from scene and list
		fire_areas[coord_pair].queue_free()
		fire_health.erase(coord_pair)
		fire_areas.erase(coord_pair)
		
		if fire_areas.size() == 0:
			gui.day_over_sequence("smokin' bonus")
	elif fire_areas.has(coord_pair):
		fire_areas[coord_pair].play_hit_flash()

func find_open_surrounding_tiles(coord_pair: Vector2i):
	var possible_coord_pairs = []
	
	# Check surrounding 8 tiles
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var cell_coord_pair = coord_pair + Vector2i(x, y)

			# If the tile is open, add it to the list
			if get_cell_tile_data(cell_coord_pair) == null:
				possible_coord_pairs.append(cell_coord_pair)
	
	return possible_coord_pairs


func add_fire_sprite(coords: Vector2i):
	var new_fire_area : Sprite2D = FIRE_DAMAGE_ZONE.instantiate()
	fire_areas[coords] = new_fire_area
	var offset : Vector2i = Vector2i(8,8)
	new_fire_area.position = coords*16 + offset
	get_tree().current_scene.add_child.call_deferred(new_fire_area)
