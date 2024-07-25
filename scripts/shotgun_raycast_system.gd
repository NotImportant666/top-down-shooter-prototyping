extends Node2D

@onready var shotgun_raycast_system = $"."

@onready var ray_cast_2d = $RayCast2D
@onready var ray_cast_2d_2 = $RayCast2D2
@onready var ray_cast_2d_3 = $RayCast2D3
@onready var ray_cast_2d_4 = $RayCast2D4
@onready var ray_cast_2d_5 = $RayCast2D5
@onready var ray_cast_2d_6 = $RayCast2D6



var raycasts : Array = []
var raycast_collision_points : Array = []

func _ready():
	raycasts = get_all_children(shotgun_raycast_system)
	print(raycasts)

func _physics_process(delta):
	for i in raycasts:
		randomize_raycast_angle(i)

func randomize_raycast_angle(individual_raycast : RayCast2D) -> void:
	individual_raycast.rotation = randf_range(-deg_to_rad(5), deg_to_rad(5))

func get_all_children(in_node,arr:=[]) -> Array:
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	arr.erase(shotgun_raycast_system)
	return arr

func get_all_raycast_collision_points() -> Array:
	for i in raycasts:
		raycast_collision_points.push_back(i.get_collision_point())
	
	return raycast_collision_points

func get_all_raycasts() -> Array:
	return raycasts

