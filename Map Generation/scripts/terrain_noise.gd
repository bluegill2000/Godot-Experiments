class_name TerrainNoise

var noise_layers: Array[TerrainNoisePair]

func height_at(x: float, z: float) -> float:
	var height: float = 0
	
	for noise_pair in noise_layers:
		height += noise_pair.noise.get_noise_2d(x, z) * noise_pair.weight
	
	return height

static func pine_forest_terrain(seed: int) -> TerrainNoise:
	var mound_noise = FastNoiseLite.new()
	mound_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	mound_noise.fractal_octaves = 3
	mound_noise.frequency = 0.04
	mound_noise.seed = seed
	
	var hill_noise = FastNoiseLite.new()
	hill_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	hill_noise.fractal_octaves = 3
	hill_noise.frequency = 0.008
	hill_noise.seed = hash(seed)
	
	var terrain_noise = TerrainNoise.new()
	terrain_noise.noise_layers.append(TerrainNoisePair.create(mound_noise, 1.4))
	terrain_noise.noise_layers.append(TerrainNoisePair.create(hill_noise, 6))
	
	return terrain_noise
