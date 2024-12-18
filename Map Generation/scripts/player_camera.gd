extends Node3D

@export var player: CharacterBody3D

const gravity_strength: float = 200
const speed: float = 500
const mouse_speed: float = -0.01

var camera_rot_x: float = 0
var camera_rot_y: float = 0
var mouse_captured: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	print("Camera controls ready")
	
	player.floor_snap_length = 5
	player.floor_max_angle = 2

func _physics_process(delta):
	var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_backward") * speed * delta
	var target = velocity.rotated(-camera_rot_x)
	var gravity = -gravity_strength * delta if not player.is_on_floor() else 0
	
	player.velocity = Vector3(target.x, gravity, target.y)
	player.move_and_slide()

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
	
	if Input.is_key_pressed(KEY_R):
		player.position = Vector3(0, 2, 0)
