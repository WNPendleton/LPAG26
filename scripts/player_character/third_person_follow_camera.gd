class_name ThirdPersonFollowCamera
extends Camera3D

@export var player_character: Player
@export var look_speed = 0.01
@export_range(0, 99, 1) var zoom_freedom = 85
@export_range(0.01, 1.0, 0.01) var y_damp_factor := 0.3
@export_range(0.01, 1.0, 0.01) var x_damp_factor := 0.5
@export_range(0.01, 1.0, 0.01) var angular_damp_factor := 0.3
@export_range(0.01, 1.0, 0.01) var moving_y_damp_factor := 0.5
@export_range(0.01, 1.0, 0.01) var moving_angular_damp_factor := 0.5

var angle = -PI / 2.0 # theta
var height = -2 # phi
var follow_scale = 5.0 # rho

var camera_moving = false
var terrain_raycast: RayCast3D
var goal_position: Vector3
var goal_basis: Basis


func _ready() -> void:
	GlobalReferences.gameplay_camera = self
	terrain_raycast = RayCast3D.new()
	(func():
		get_parent().add_child(terrain_raycast)
		terrain_raycast.owner = get_parent().owner).call_deferred()


func _physics_process(_delta: float) -> void:
	handle_controller_camera_inputs()
	calculate_goal_position_and_rotation()
	update_position_and_rotation()
	camera_moving = false


func _input(event):
	if event is InputEventMouseMotion:
		apply_camera_rotation(event.relative)
		if event.relative.y != 0:
			camera_moving = true


func handle_controller_camera_inputs():
	var controller_look_dir = Input.get_vector("look-left", "look-right", "look-up", "look-down")
	if controller_look_dir.y != 0:
		camera_moving = true
	apply_camera_rotation(controller_look_dir * 5.0)


func apply_camera_rotation(relative: Vector2):
	angle += relative.x * look_speed
	angle = fmod(angle, TAU)
	height += relative.y * look_speed
	height = clamp(height, -PI * zoom_freedom / 100.0, -PI * (1 - zoom_freedom / 100.0))


func calculate_goal_position_and_rotation():
	var origin = player_character.global_position + Vector3(0, follow_scale, 0)
	var vector = spherical_to_cartesian(follow_scale, angle, height)
	goal_position = origin + vector
	var dir  = player_character.global_position.direction_to(goal_position)
	if terrain_raycast.is_inside_tree():
		terrain_raycast.global_position = player_character.global_position + dir * 0.01
		terrain_raycast.target_position = goal_position - terrain_raycast.global_position
	if terrain_raycast.is_colliding():
		goal_position = terrain_raycast.get_collision_point() - dir * 0.2
	var goal_dir = global_position.direction_to(player_character.global_position)
	goal_basis = Basis.looking_at(goal_dir)


func update_position_and_rotation():
	global_position.x = lerp(global_position.x, goal_position.x, x_damp_factor)
	global_position.y = lerp(global_position.y, goal_position.y, moving_y_damp_factor if camera_moving else y_damp_factor)
	global_position.z = lerp(global_position.z, goal_position.z, x_damp_factor)
	basis = basis.slerp(goal_basis, moving_angular_damp_factor if camera_moving else angular_damp_factor)


func spherical_to_cartesian(rho: float, theta: float, phi: float) -> Vector3:
	var sin_phi = sin(phi)
	return Vector3(rho * sin_phi * cos(theta), rho * cos(phi), rho * sin_phi * sin(theta))


func jump():
	var origin = player_character.global_position + Vector3(0, follow_scale, 0)
	var vector = spherical_to_cartesian(follow_scale, angle, height)
	global_position = origin + vector
	var goal_dir = global_position.direction_to(player_character.global_position)
	goal_basis = Basis.looking_at(goal_dir)
	basis = goal_basis
