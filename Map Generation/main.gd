extends Node

@export var sprite: Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_R:
			generateImage()

func generateImage():
	print("Generating image!")
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 1
	noise.fractal_octaves = 4
	noise.fractal_lacunarity = 5
	noise.fractal_gain = 0.01
	
	var image = noise.get_image(50, 50)
	sprite.texture = ImageTexture.create_from_image(image)
