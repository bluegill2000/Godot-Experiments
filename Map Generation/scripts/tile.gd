extends Node3D

const tileSize = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func configure(mapSeed: int, tile_type: Globals.WorldType, x: int, z: int):
	# Clean tile
	for child in get_children():
		child.queue_free()
	
	position.x = x * tileSize
	position.z = z * tileSize
	
	var generator = RandomNumberGenerator.new()
	generator.seed = x * z + mapSeed # Each tile has a 'different' seed
	
	if tile_type == Globals.WorldType.pine_forest:
		# Trees 1-4
		print("Generating trees based at " + str(position.x) + " " + str(position.z) + " with a tile size " + str(tileSize))
		for i in generator.randi_range(1, 4):
			var tree_node = Sprite3D.new()
			var image = Image.new()
			image.load("res://assets/pine forest/pine_tree_1.png")
			tree_node.texture = ImageTexture.create_from_image(image)
			tree_node.position.x = generator.randf_range(0, tileSize)
			tree_node.position.z = generator.randf_range(0, tileSize)
			
			tree_node.position.y = tree_node.scale.y / 2
			#tree_node.position.y = tree_node.texture.get_height() / 2
			print("Generated tree at " + str(tree_node.position.x) + " " + str(tree_node.position.z) + " positioned above " + str(tree_node.position.y))
			add_child(tree_node)
