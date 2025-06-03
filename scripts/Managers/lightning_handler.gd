extends Node2D

const LIGHTNING = preload("res://scenes/lightning.tscn")

@onready var fire_tiles: FireTiles = $"../FireTiles"
@export var max_lightning : int = 5
func _ready() -> void:
	
	# Spawn a random number of lightnings (1-5) can tweak this number
	for i in randi() % max_lightning:
		spawn_lightning()

func spawn_lightning():
	var cells = get_empty_cells()
	
	#remove house + nearby (+- 3 tiles) from empty cells
	var house_min = Vector2i(-4,-6)
	var house_max = Vector2i(4,4)
	
	for x in range(house_min.x, house_max.x + 1):
		for y in range(house_min.y, house_max.y + 1):
				var house_coord = Vector2i(x, y)
				if cells.has(house_coord):
					cells.erase(house_coord)

	#create new lightning then move it to random cell, 
	#shift for correct sprite and spawn fire
	
	var new_lightning = LIGHTNING.instantiate()
	var coord = cells.pick_random()
	var new_pos = to_global(fire_tiles.map_to_local(coord))
	new_lightning.global_position = new_pos + Vector2(0,-64)
	add_child(new_lightning)
	
	await new_lightning.animation_finished
	#await get_tree().create_timer(0.25).timeout
	
	fire_tiles.set_cell(coord, 0, Vector2i(0, 0))
	fire_tiles.fire_health[coord] = fire_tiles.starting_health
	fire_tiles.add_fire_sprite(coord)
	
func get_empty_cells(tiles = fire_tiles, min_tile = Vector2i(-20,-5), max_tile = Vector2i(19,10)) -> Array:
	var empty_cells := []

	for x in range(min_tile.x, max_tile.x):
		for y in range(min_tile.y, max_tile.y):
			var coord = Vector2i(x, y)
			if tiles.get_cell_tile_data(coord) == null:
				empty_cells.append(coord)

	return empty_cells
