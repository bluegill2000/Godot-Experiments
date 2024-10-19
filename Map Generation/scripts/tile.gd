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
		for i in generator.randi_range(1, 4):
			var tree_texture_number = generator.randi_range(1, 4)
			var tree_node = Sprite3D.new()
			var image = Image.new()
			image.load("res://assets/pine forest/pine_tree_" + str(tree_texture_number) + ".png")
			tree_node.texture = ImageTexture.create_from_image(image)
			tree_node.position.x = generator.randf_range(0, tileSize)
			tree_node.position.z = generator.randf_range(0, tileSize)
			
			# Scale the trees
			tree_node.pixel_size *= generator.randf_range(0.7, 1.3)
			
			var image_height = tree_node.texture.get_height() * tree_node.pixel_size
			tree_node.position.y = image_height / 2
			
			add_child(tree_node)
		
		# Rocks 0-1
		if generator.randi() % 2:
			var rock_texture_number = generator.randi_range(1, 2)
			var rock_node = Sprite3D.new()
			var image = Image.new()
			image.load("res://assets/pine forest/rock_" + str(rock_texture_number) + ".png")
			rock_node.texture = ImageTexture.create_from_image(image)
			rock_node.position.x = generator.randf_range(0, tileSize)
			rock_node.position.z = generator.randf_range(0, tileSize)
			
			# Shrink rocks down
			rock_node.pixel_size = rock_node.pixel_size * 0.3
			
			var image_height = rock_node.texture.get_height() * rock_node.pixel_size
			rock_node.position.y = image_height / 2
			
			add_child(rock_node)
		
		# Fallen logs 0-1
		if generator.randi() % 2:
			var log_node = Sprite3D.new()
			var image = Image.new()
			image.load("res://assets/pine forest/fallen_log_1.png")
			log_node.texture = ImageTexture.create_from_image(image)
			log_node.position.x = generator.randf_range(0, tileSize)
			log_node.position.z = generator.randf_range(0, tileSize)
			
			# Rotate log
			log_node.rotate_z(deg_to_rad(-45))
			
			var image_height = log_node.texture.get_height() * log_node.pixel_size
			log_node.position.y = image_height / 2
			
			add_child(log_node)
