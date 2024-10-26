class_name BigFoot
extends CharacterBody3D

var player_node: Node3D

const walking_speed = 4
const running_speed = 9
const comfort_limit = 10
const flee_distance = 17
const packed_scene: PackedScene = preload("res://prefabs/big_foot.tscn")

var target: Vector3 = Vector3(0, 0, 0)
var is_fleeing = false

static func new_big_foot(player: Node3D) -> BigFoot:
	var big_foot = packed_scene.instantiate()
	big_foot.player_node = player
	
	return big_foot

func _ready():
	create_new_target()

func create_new_target():
	var found_target: bool = false
	
	while !found_target:
		var rand_x = randf_range(0, Globals.rows * 10) + (Globals.row_offset * 10)
		var rand_z = randf_range(0, Globals.cols * 10) + (Globals.col_offset * 10)
		
		var new_target = Vector3(rand_x, 0, rand_z)
		if target.distance_to(new_target) > 10:
			target = new_target
			found_target = true
			is_fleeing = false

func _physics_process(delta: float) -> void:
	var direction: Vector3
	var speed: float
	
	# Always run away form the player if they are too close
	if !is_fleeing and position.distance_to(player_node.position) < comfort_limit:
		direction = position.direction_to(player_node.position) * -1
		direction.y = 0
		direction *= flee_distance
		target = position + direction
		is_fleeing = true
	
	direction = position.direction_to(target)
	speed = running_speed if is_fleeing else walking_speed
	
	velocity = direction * speed
	
	move_and_slide()
	
	if position.distance_to(target) < 0.5:
		create_new_target()
