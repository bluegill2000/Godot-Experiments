extends Node3D

const pine_tree_1_scene = preload("res://prefabs/pine_forest/pine_tree_1.tscn")
const pine_tree_2_scene = preload("res://prefabs/pine_forest/pine_tree_2.tscn")
const pine_tree_3_scene = preload("res://prefabs/pine_forest/pine_tree_3.tscn")
const pine_tree_4_scene = preload("res://prefabs/pine_forest/pine_tree_4.tscn")
const fallen_log_1_scene = preload("res://prefabs/pine_forest/fallen_log_1.tscn")
const rock_1_scene = preload("res://prefabs/pine_forest/rock_1.tscn")
const rock_2_scene = preload("res://prefabs/pine_forest/rock_2.tscn")

const tile_size = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func configure(mapSeed: int, tile_type: Globals.WorldType, x: int, z: int):
	position.x = x * tile_size
	position.z = z * tile_size
	
	var generator = RandomNumberGenerator.new()
	generator.seed = hash(str(x) + str(z) + str(mapSeed)) # Each tile has a 'different' seed
	
	if tile_type == Globals.WorldType.pine_forest:
		var tree_count = generator.randi_range(2, 7)
		var log_count = 1 if generator.randi_range(0, 3) == 0 else 0
		var rock_count = 1 if generator.randi_range(0, 4) == 0 else 0
		var locations = PointCloudGenerator.generate_points(tile_size - 1, tile_size - 1, tree_count + log_count + rock_count, 1.5, generator.seed)
		
		for i in range(0, tree_count - 1):
			var location = locations[i]
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
			
			tree_node.position.x = location.x
			tree_node.position.z = location.y
			
			# Scale the trees
			tree_node.find_child("tree_sprite").pixel_size *= generator.randf_range(0.7, 1.3)
			
			add_child(tree_node)
		
		if rock_count == 1:
			var location = locations[tree_count]
			var rock_node: Node3D
			
			match generator.randi_range(1, 2):
				1:
					rock_node = rock_1_scene.instantiate()
				2:
					rock_node = rock_2_scene.instantiate()
			
			rock_node.position.x = location.x
			rock_node.position.z = location.y
			
			# Shrink rocks down
			rock_node.scale *= generator.randf_range(0.3, 0.5)
			
			# Rotate rocks
			rock_node.rotate_y(deg_to_rad(generator.randi_range(0, 359)))
			
			add_child(rock_node)
		
		if log_count == 1:
			var location = locations[tree_count + rock_count]
			var log_node = fallen_log_1_scene.instantiate()
			log_node.position.x = location.x
			log_node.position.z = location.y
			
			# Rotate log
			log_node.rotate_y(deg_to_rad(generator.randi_range(0, 359)))
			
			add_child(log_node)
