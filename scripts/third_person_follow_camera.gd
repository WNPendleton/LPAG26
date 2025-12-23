extends Camera3D

@export var look_speed = 0.01
@export_range(0, 99, 1) var zoom_freedom = 85
@export var player_character: Player

var follow_scale = 5.0 # rho
var orbit_phase = -PI / 2.0 # theta
var orbit_height = -2 # phi


func _physics_process(_delta: float) -> void:
	handle_controller_camera_inputs()
	update_position_and_rotation()


func _input(event):
	if event is InputEventMouseMotion:
		apply_camera_rotation(event.relative)


func handle_controller_camera_inputs():
	var controller_look_dir = Input.get_vector("look-left", "look-right", "look-up", "look-down")
	apply_camera_rotation(controller_look_dir * 5.0)


func apply_camera_rotation(relative: Vector2):
	orbit_phase += relative.x * look_speed
	orbit_phase = fmod(orbit_phase, TAU)
	orbit_height += relative.y * look_speed
	orbit_height = clamp(orbit_height, -PI * zoom_freedom / 100.0, -PI * (1 - zoom_freedom / 100.0))


func update_position_and_rotation():
	var origin = player_character.global_position + Vector3(0, follow_scale, 0)
	var vector = spherical_to_cartesian(follow_scale, orbit_phase, orbit_height)
	global_position = origin + vector
	look_at(player_character.global_position)


func spherical_to_cartesian(rho: float, theta: float, phi: float) -> Vector3:
	var sin_phi = sin(phi)
	return Vector3(rho * sin_phi * cos(theta), rho * cos(phi), rho * sin_phi * sin(theta))
