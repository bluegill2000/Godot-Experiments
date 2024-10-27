extends Node

@export var tileContainer: Node
@export var player_node: Node3D

const tile_scene = preload("res://prefabs/pine_forest/pine_forest_tile.tscn")
const coordinateMultiplier: float = 5
const tileTexturePath: String = "res://assets/misc/grass_tile_texture.jpg"
const tileScriptPath: String = "res://scripts/tile.gd"

var tiles: Array[Sprite3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generate tile set
	var world_seed: int = randi()
	var terrain = TerrainNoise.pine_forest_terrain(world_seed)
	
	for row in range(Globals.row_offset, Globals.row_offset + Globals.rows):
		for col in range(Globals.col_offset, Globals.col_offset + Globals.cols):
			var tile = tile_scene.instantiate()
			
			tileContainer.add_child(tile)
			tile.configure(world_seed, Globals.WorldType.pine_forest, row, col, terrain)
	
	return
	# Invite Bigfoot
	var world_width_min = -Globals.row_offset
	var world_width_max = 10 * Globals.rows - Globals.row_offset
	var world_depth_min = -Globals.col_offset
	var world_depth_max = 10 * Globals.cols - Globals.col_offset
	
	var big_foot = BigFoot.new_big_foot(player_node)
	big_foot.position = Vector3(randf_range(world_width_min, world_width_max), 0, randf_range(world_depth_min, world_depth_max))
	
	add_child(big_foot)
