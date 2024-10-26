class_name PointCloudGenerator

static func generate_points(width: float, height: float, count: int, clearance: float, random_seed: int) -> Array[Vector2]:
	var generator = RandomNumberGenerator.new()
	var points: Array[Vector2] = []
	
	generator.seed = random_seed
	
	while points.size() < count:
		var point_fits: bool = true
		var new_point = Vector2(generator.randf_range(0, width), generator.randf_range(0, height))
		
		for point in points:
			if point.distance_to(new_point) < clearance:
				point_fits = false
				break
		
		if point_fits:
			points.append(new_point)
	
	return points
