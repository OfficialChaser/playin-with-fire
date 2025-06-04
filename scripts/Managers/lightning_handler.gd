extends Node2D

const LIGHTNING = preload("res://scenes/Objects/lightning.tscn")
const LIGHTNING_HIGHLIGHT = preload("res://scenes/Objects/lightning_highlight.tscn")

@onready var fire_tiles: FireTiles = $"../FireTiles"
@export var min_lightning : int = 1
@export var max_lightning : int = 2
func _ready() -> void:
	if GameManager.day > 1:
		await GameManager.rule_selected
	var used_cells := {}
	
	for i in randi_range(min_lightning, max_lightning):
		await get_tree().create_timer(0.1).timeout
		spawn_lightning(used_cells)

func spawn_lightning(used_cells: Dictionary):
	var empty_cells = get_empty_cells()
	
	# Filter out used cells
	empty_cells = empty_cells.filter(func(cell): return !used_cells.has(cell))
	if empty_cells.is_empty():
		return

	
	var coord = empty_cells.pick_random()
	var new_pos = to_global(fire_tiles.map_to_local(coord))
	
	var new_lightning_highlight = LIGHTNING_HIGHLIGHT.instantiate()
	new_lightning_highlight.global_position = new_pos
	add_child(new_lightning_highlight)
	
	await get_tree().create_timer(GameManager.lightning_delay_time).timeout
	
	# Instantiate lightning
	var new_lightning = LIGHTNING.instantiate()
	new_lightning.global_position = new_pos + Vector2(0,-64)
	add_child(new_lightning)

	await new_lightning.animation_finished

	# These are all the coords that will be affected by the lightning
	var affected_coords = [
		coord,
		coord + Vector2i(0, -1),
		coord + Vector2i(0, 1),
		coord + Vector2i(-1, 0),
		coord + Vector2i(1, 0)
	]

	for offset_coord in affected_coords:
		if get_empty_cells().has(offset_coord):  # Optional: still check boundary
			set_cell_to_fire(offset_coord)
			used_cells[offset_coord] = true  # Mark as used

	
func get_empty_cells(tiles = fire_tiles, min_tile = Vector2i(-15,-11), max_tile = Vector2i(15,11)) -> Array:
	var possible_cells := []
	
	for x in range(min_tile.x, max_tile.x):
		for y in range(min_tile.y, max_tile.y):
			var coord = Vector2i(x, y)
			if !tiles.get_cell_tile_data(coord) or !tiles.get_cell_tile_data(coord).get_custom_data("boundary") and !tiles.fire_health.has(coord):
				possible_cells.append(coord)
	
	#remove house + nearby (+- 5 tiles) from empty cells
	var house_min = Vector2i(-7,-8)
	var house_max = Vector2i(6,6)
	
	for x in range(house_min.x, house_max.x + 1):
		for y in range(house_min.y, house_max.y + 1):
				var house_coord = Vector2i(x, y)
				if possible_cells.has(house_coord):
					possible_cells.erase(house_coord)
	
	return possible_cells

func set_cell_to_fire(coord: Vector2i):
	fire_tiles.set_cell(coord, 0, Vector2i(0, 0))
	fire_tiles.fire_health[coord] = fire_tiles.starting_health
	fire_tiles.add_fire_sprite(coord)
