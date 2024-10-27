extends Node3D

const pine_tree_1_scene = preload("res://prefabs/pine_forest/pine_tree_1.tscn")
const pine_tree_2_scene = preload("res://prefabs/pine_forest/pine_tree_2.tscn")
const pine_tree_3_scene = preload("res://prefabs/pine_forest/pine_tree_3.tscn")
const pine_tree_4_scene = preload("res://prefabs/pine_forest/pine_tree_4.tscn")
const fallen_log_1_scene = preload("res://prefabs/pine_forest/fallen_log_1.tscn")
const rock_1_scene = preload("res://prefabs/pine_forest/rock_1.tscn")
const rock_2_scene = preload("res://prefabs/pine_forest/rock_2.tscn")
const grass_texture = preload("res://materials/grass.tres")

const tile_size = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func configure(mapSeed: int, tile_type: Globals.WorldType, x: int, z: int, noise: TerrainNoise):
	position.x = x * tile_size
	position.z = z * tile_size
	
	# Create terrain
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(tile_size, tile_size)
	plane_mesh.subdivide_depth = 10
	plane_mesh.subdivide_width = 10
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh, 0)
	
	var plane_array = surface_tool.commit()
	var data_tool = MeshDataTool.new()
	data_tool.create_from_surface(plane_array, 0)
	
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.height_at(vertex.x + (x * 10), vertex.z + (z * 10))
		
		data_tool.set_vertex(i, vertex)
	
	plane_array.clear_surfaces()
	
	data_tool.commit_to_surface(plane_array)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(plane_array, 0)
	surface_tool.generate_normals()
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.material_override = grass_texture
	add_child(mesh_instance)
	
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = mesh_instance.mesh.create_convex_shape(true, true)
	$static_body.add_child(collision_shape)
	
	# Terrain entities
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
			tree_node.position.y = noise.height_at(location.x + (x * 10), location.y + (z * 10))
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
			rock_node.position.y = noise.height_at(location.x + (x * 10), location.y + (z * 10))
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
			log_node.position.y = noise.height_at(location.x + (x * 10), location.y + (z * 10))
			log_node.position.z = location.y
			
			# Rotate log
			log_node.rotate_y(deg_to_rad(generator.randi_range(0, 359)))
			
			add_child(log_node)
