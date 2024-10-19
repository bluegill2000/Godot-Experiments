extends Node3D

const speed: float = 6
const mouse_speed: float = -0.01

var camera_rot_x: float = 0
var camera_rot_y: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Camera controls ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_backward") * speed * delta
	
	var elevation = Input.get_axis("move_down", "move_up") * speed * delta
	position += global_transform.basis * Vector3(velocity.x, elevation,  velocity.y, )

func _input(event: InputEvent):
	# Enable/Disable mouse capture
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	
	# Rotational movement
	if event is InputEventMouseMotion and Input.MOUSE_MODE_CAPTURED:
		camera_rot_x += event.relative.x * mouse_speed
		camera_rot_y += event.relative.y * mouse_speed
		
		camera_rot_y = clamp(camera_rot_y, deg_to_rad(-90), deg_to_rad(90))
		
		transform.basis = Basis()
		rotate_object_local(Vector3.UP, camera_rot_x)
		rotate_object_local(Vector3.RIGHT, camera_rot_y)
