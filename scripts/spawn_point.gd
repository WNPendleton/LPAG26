@tool
class_name SpawnPoint
extends Marker3D

@onready var camera_marker : Marker3D = get_node_or_null("CameraAngle")

@export var current := false
@export_range(0, PI * 2.0, 0.1) var camera_angle = 0.0: # theta
	set(value):
		camera_angle = value
		update()
@export_range(-PI, 0, 0.1) var camera_height = -2.0: # phi
	set(value):
		camera_height = value
		update()
@export_range(0.0, 10.0, 0.1) var camera_distance = 5.0: # rho
	set(value):
		camera_distance = value
		update()
		

func _ready() -> void:
	if not is_instance_valid(camera_marker):
		for child in get_children():
			child.queue_free()
		camera_marker = Marker3D.new()
		camera_marker.position = Vector3(0, camera_distance, 0) + spherical_to_cartesian(camera_distance, camera_angle, camera_height)
		camera_marker.name = "CameraAngle"
		add_child.call_deferred(camera_marker)
		(func set_owner(): camera_marker.owner = owner).call_deferred()
		camera_marker.look_at.call_deferred(global_position)
	if current:
		GlobalReferences.player_character.set_spawn(self, true)


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return


func spawn(player: Player, camera: ThirdPersonFollowCamera = null):
	player.global_position = global_position
	player.rotation = rotation
	if camera:
		camera.follow_scale = camera_distance
		camera.angle = camera_angle - rotation.y
		camera.height = camera_height


func spherical_to_cartesian(rho: float, theta: float, phi: float) -> Vector3:
	var sin_phi = sin(phi)
	return Vector3(rho * sin_phi * cos(theta), rho * cos(phi), rho * sin_phi * sin(theta))


func update():
	if camera_marker:
		camera_marker.position = Vector3(0, camera_distance, 0) + spherical_to_cartesian(camera_distance, camera_angle, camera_height)
		camera_marker.look_at(global_position)
