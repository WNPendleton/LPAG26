extends Area3D

@export var destination : SpawnPoint
@export var key_name := ""

var screen_transition = GlobalReferences.screen_transition


func _ready() -> void:
	if not is_instance_valid(screen_transition):
		push_warning("Unable to find screen transition for " + str(get_path()))


func _on_body_entered(body: Node3D) -> void:
	if body is Player and ((not key_name) or body.has_inventory_item(key_name)):
		screen_transition.cover_with_callback(teleport_player.bind(body))


func teleport_player(body):
	destination.spawn(body, GlobalReferences.gameplay_camera)
	await get_tree().create_timer(0.5).timeout
	screen_transition.reveal()
