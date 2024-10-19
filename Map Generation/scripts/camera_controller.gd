extends Node3D

const speed: float = 0.03
const mouse_speed: float = 0.3

#var camera_anlge: float = 0
var camera_pitch: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Camera controls ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_UP):
		position.z -= speed
	elif Input.is_key_pressed(KEY_DOWN):
		position.z += speed
	
	if Input.is_key_pressed(KEY_RIGHT):
		position.x += speed
	elif Input.is_key_pressed(KEY_LEFT):
		position.x -= speed
	
	if Input.is_key_pressed(KEY_SPACE):
		position.y += speed
	elif Input.is_key_pressed(KEY_SHIFT):
		position.y -= speed

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var yaw = event.relative.x
		var pitch = event.relative.y
		
		pitch = clamp(pitch, -90 - camera_pitch, 90 - camera_pitch)
		camera_pitch += pitch
		
		rotate_y(deg_to_rad((-yaw)))
		rotate_object_local(Vector3(1, 0, 0), deg_to_rad(-pitch))
		#rotate_y(deg_to_rad(-event.relative.x * mouse_speed))
		#
		#var changev = -event.relative.y * mouse_speed
		#if camera_anlge + changev > -50 and camera_anlge + changev < 50:
			#camera_anlge += changev
			#rotate_x(deg_to_rad(changev))
