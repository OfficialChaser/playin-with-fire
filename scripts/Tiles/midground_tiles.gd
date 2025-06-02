extends TileMapLayer
class_name MidgroundLayer

var tree_coords : Dictionary = {} # Coords : Coords
var tree_coverage : Dictionary = {} # Covered Tiles : Coords
var tree_fires : Dictionary = {}  # Covered Tiles : Coords

func _ready() -> void:

	for coords in get_used_cells():
		var tile_data = get_cell_tile_data(coords)
		if tile_data and tile_data.get_custom_data("tree"):
			tree_coords[coords] = coords
			tile_data.set_custom_data('burning', false)
			var size = tile_data.get_custom_data("tree_size")
			for x in range(size.x):
				for y in range(size.y):
					var covered_tile = coords + Vector2i(x, -y)  
					tree_coverage[covered_tile] = coords
