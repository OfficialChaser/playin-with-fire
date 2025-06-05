extends TileMapLayer

var player : Player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if !GameManager.darkness_enabled:
		set_all_tiles(false)
		return
	set_all_tiles(true)
	

func set_all_tiles(on: bool, level: int = 1):
	z_index = 1
	if not on:
		for coords in get_used_cells():
			set_cell(coords, 0, Vector2i(0, 0))
		return
	
	if level == 1:
		for coords in get_used_cells():
			var dist = map_to_local(coords).distance_to(player.global_position)
			if dist < 50:
				set_cell(coords, 0, Vector2i(0, 0))
			elif dist < 100:
				set_cell(coords, 0, Vector2i(2, 0))
			elif dist < 150:
				set_cell(coords, 0, Vector2i(3, 0))
			else:
				set_cell(coords, 0, Vector2i(4, 0))
