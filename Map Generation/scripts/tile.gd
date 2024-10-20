extends Node3D

const pine_tree_1_scene = preload("res://prefabs/pine_forest/pine_tree_1.tscn")
const pine_tree_2_scene = preload("res://prefabs/pine_forest/pine_tree_2.tscn")
const pine_tree_3_scene = preload("res://prefabs/pine_forest/pine_tree_3.tscn")
const pine_tree_4_scene = preload("res://prefabs/pine_forest/pine_tree_4.tscn")
const fallen_log_1_scene = preload("res://prefabs/pine_forest/fallen_log_1.tscn")
const rock_1_scene = preload("res://prefabs/pine_forest/rock_1.tscn")
const rock_2_scene = preload("res://prefabs/pine_forest/rock_2.tscn")

const tileSize = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func configure(mapSeed: int, tile_type: Globals.WorldType, x: int, z: int):
	position.x = x * tileSize
	position.z = z * tileSize
	
	var generator = RandomNumberGenerator.new()
	generator.seed = x * z + mapSeed # Each tile has a 'different' seed
	
	if tile_type == Globals.WorldType.pine_forest:
		# Trees 1-4
		for i in generator.randi_range(1, 4):
			var tree_node: Node3D
			
			match generator.randi_range(1, 4):
				1:
					tree_node = pine_tree_1_scene.instantiate()
				2:
					tree_node = pine_tree_2_scene.instantiate()
				3:
					tree_node = pine_tree_3_scene.instantiate()
				4:
					tree_node = pine_tree_4_scene.instantiate()
			
			tree_node.position.x = generator.randf_range(0, tileSize)
			tree_node.position.z = generator.randf_range(0, tileSize)
			
			# Scale the trees
			tree_node.find_child("tree_sprite").pixel_size *= generator.randf_range(0.7, 1.3)
			
			add_child(tree_node)
		
		# Rocks 0-1
		if generator.randi() % 2:
			var rock_node: Node3D
			match generator.randi_range(1, 2):
				1:
					rock_node = rock_1_scene.instantiate()
				2:
					rock_node = rock_2_scene.instantiate()
			
			rock_node.position.x = generator.randf_range(0, tileSize)
			rock_node.position.z = generator.randf_range(0, tileSize)
			
			# Shrink rocks down
			rock_node.scale *= generator.randf_range(0.3, 0.5)
			
			# Rotate rocks
			rock_node.rotate_y(deg_to_rad(generator.randi_range(0, 359)))
			
			add_child(rock_node)
		
		# Fallen logs 0-1
		if generator.randi() % 2:
			var log_node = fallen_log_1_scene.instantiate()
			log_node.position.x = generator.randf_range(0, tileSize)
			log_node.position.z = generator.randf_range(0, tileSize)
			
			# Rotate log
			log_node.rotate_y(deg_to_rad(generator.randi_range(0, 359)))
			
			add_child(log_node)
