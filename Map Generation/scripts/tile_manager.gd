extends Node

@export var tileContainer: Node

const tile_scene = preload("res://prefabs/pine_forest/pine_forest_tile.tscn")
const rowOffset: int = -4
const colOffset: int = -4
const rows: int = 6
const cols: int = 6
const coordinateMultiplier: float = 5
const tileTexturePath: String = "res://assets/misc/grass_tile_texture.jpg"
const tileScriptPath: String = "res://scripts/tile.gd"

var tiles: Array[Sprite3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generate tile set
	var worldSeed: int = randi()
	for row in range(rowOffset, rowOffset + rows):
		for col in range(colOffset, colOffset + cols):
			var tile = tile_scene.instantiate()
			
			tileContainer.add_child(tile)
			tile.configure(worldSeed, Globals.WorldType.pine_forest, row, col)
