class_name TerrainNoisePair

var noise: FastNoiseLite
var weight: float

static func create(noise: FastNoiseLite, weight: float) -> TerrainNoisePair:
	var pair = TerrainNoisePair.new()
	pair.noise = noise
	pair.weight = weight
	
	return pair
