extends Node3D

const speed: float = 6
const mouse_speed: float = 0.3

#var camera_anlge: float = 0
var camera_pitch: float = 0

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
		var yaw = event.relative.x
		var pitch = event.relative.y
		
		pitch = clamp(pitch, -90 - camera_pitch, 90 - camera_pitch)
		camera_pitch += pitch
		
		rotate_y(deg_to_rad((-yaw)))
		rotate_object_local(Vector3(1, 0, 0), deg_to_rad(-pitch))
