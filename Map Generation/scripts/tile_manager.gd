extends Node

@export var tileContainer: Node
@export var player_node: Node3D

const tile_scene = preload("res://prefabs/pine_forest/pine_forest_tile.tscn")
const rowOffset: int = -4
const colOffset: int = -4
const rows: int = 8
const cols: int = 8
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
	
	# Invite Bigfoot
	var big_foot = BigFoot.new_big_foot(80, -40, player_node)
	big_foot.position = Vector3(-50, 0, -50)
	
	add_child(big_foot)
