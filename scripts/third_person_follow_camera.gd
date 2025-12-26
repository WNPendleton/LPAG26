extends Camera3D

@export var look_speed = 0.01
@export_range(0, 99, 1) var zoom_freedom = 85
@export var player_character: Player
@export_range(0.01, 1.0, 0.01) var y_damp_factor := 0.01
@export_range(0.01, 1.0, 0.01) var x_damp_factor := 0.5
@export_range(0.01, 1.0, 0.01) var angular_damp_factor := 0.01
@export_range(0.01, 1.0, 0.01) var moving_y_damp_factor := 0.5
@export_range(0.01, 1.0, 0.01) var moving_angular_damp_factor := 0.5

@export_group("Initial Position")
@export var angle = -PI / 2.0 # theta
@export var height = -2 # phi
var follow_scale = 5.0 # rho

var camera_moving = false


func _ready() -> void:
	GlobalReferences.gameplay_camera = self


func _physics_process(_delta: float) -> void:
	handle_controller_camera_inputs()
	update_position_and_rotation()


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


func update_position_and_rotation():
	var origin = player_character.global_position + Vector3(0, follow_scale, 0)
	var vector = spherical_to_cartesian(follow_scale, angle, height)
	global_position.x = lerp(global_position.x, (origin + vector).x, x_damp_factor)
	global_position.y = lerp(global_position.y, (origin + vector).y, moving_y_damp_factor if camera_moving else y_damp_factor)
	global_position.z = lerp(global_position.z, (origin + vector).z, x_damp_factor)
	var goal_dir = global_position.direction_to(player_character.global_position)
	var goal_basis = Basis.looking_at(goal_dir)
	basis = basis.slerp(goal_basis, moving_angular_damp_factor if camera_moving else angular_damp_factor)
	camera_moving = true


func spherical_to_cartesian(rho: float, theta: float, phi: float) -> Vector3:
	var sin_phi = sin(phi)
	return Vector3(rho * sin_phi * cos(theta), rho * cos(phi), rho * sin_phi * sin(theta))
