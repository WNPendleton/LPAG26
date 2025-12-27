extends Area3D

@export var destination := Vector3(0, 5, 0)
@export var key_name := ""

var screen_transition


func _ready() -> void:
	screen_transition = get_tree().root.get_node_or_null("Game/GUI/ScreenTransition")
	if not is_instance_valid(screen_transition):
		push_warning("Unable to find screen transition for " + str(get_path()))


func _on_body_entered(body: Node3D) -> void:
	if body is Player and body.has_inventory_item(key_name):
		screen_transition.cover_with_callback(teleport_player.bind(body))


func teleport_player(body):
	body.global_position = destination
	await get_tree().create_timer(1.0).timeout
	screen_transition.reveal()
