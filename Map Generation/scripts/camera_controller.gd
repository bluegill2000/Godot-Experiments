extends Node3D

const speed: float = 6
const mouse_speed: float = -0.01

var camera_rot_x: float = 0
var camera_rot_y: float = 0
var mouse_captured: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	print("Camera controls ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var forward = Input.get_axis("move_forward", "move_backward") * speed * delta
	var lateral = Input.get_axis("move_left", "move_right") * speed * delta
	var elevation = Input.get_axis("move_down", "move_up") * speed * delta
	
	var to_local_basis = global_transform.basis
	var local_movement = to_local_basis * Vector3(lateral, 0, forward)
	
	position.x += local_movement.x
	position.y += elevation
	position.z += local_movement.z

func _input(event: InputEvent):
	# Enable/Disable mouse capture
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_captured = false
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_captured = true
	elif Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_captured = false
	
	# Rotational movement
	if event is InputEventMouseMotion and mouse_captured:
		camera_rot_x += event.relative.x * mouse_speed
		camera_rot_y += event.relative.y * mouse_speed
		
		camera_rot_y = clamp(camera_rot_y, deg_to_rad(-90), deg_to_rad(90))
		
		transform.basis = Basis()
		rotate_object_local(Vector3.UP, camera_rot_x)
		rotate_object_local(Vector3.RIGHT, camera_rot_y)
