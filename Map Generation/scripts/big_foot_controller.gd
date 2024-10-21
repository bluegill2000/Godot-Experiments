class_name BigFoot
extends CharacterBody3D

var world_size: int
var world_offset: int

const walking_speed = 4
const packed_scene: PackedScene = preload("res://prefabs/big_foot.tscn")

var target: Vector3 = Vector3(0, 0, 0)

static func new_big_foot(world_size: int, world_offset: int) -> BigFoot:
	var big_foot = packed_scene.instantiate()
	big_foot.world_size = world_size
	big_foot.world_offset = world_offset
	
	return big_foot

func _ready():
	create_new_target()

func create_new_target():
	var found_target: bool = false
	
	while !found_target:
		var rand_x = randf_range(0, world_size) + world_offset
		var rand_z = randf_range(0, world_size) + world_offset
		
		var new_target = Vector3(rand_x, 0, rand_z)
		if target.distance_to(new_target) > 10:
			target = new_target
			found_target = true
	
	print("Big foot moving toward " + str(target))

func _physics_process(delta: float) -> void:
	# Fingure out where to go
	var direction = position.direction_to(target)
	velocity = direction * walking_speed
	
	move_and_slide()
	
	if position.distance_to(target) < 0.5:
		create_new_target()
