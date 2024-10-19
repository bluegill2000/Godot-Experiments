extends Node

@export var tileContainer: Node

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
	var script = load(tileScriptPath)
	var worldSeed: int = randi()
	var counter := 1
	for row in range(rowOffset, rowOffset + rows):
		for col in range(colOffset, colOffset + cols):
			var tile = Sprite3D.new()
			tile.set_script(script)
			
			# Tile contents
			tile.configure(worldSeed, Globals.WorldType.pine_forest, row, col)
			
			# Tile background
			var tileImage = Sprite3D.new()
			var image = Image.new()
			image.load(tileTexturePath)
			var texture = ImageTexture.create_from_image(image)
			var textureSize = texture.get_size()
			tileImage.axis = Vector3.AXIS_Y
			tileImage.texture = texture
			tileImage.scale = Vector3(1000 / textureSize.x, 1, 1000 / textureSize.y)
			tileImage.position.x = 5
			tileImage.position.z = 5
			tile.add_child(tileImage)
			
			tileContainer.add_child(tile)
			counter += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
