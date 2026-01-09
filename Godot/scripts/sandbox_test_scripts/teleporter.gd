extends Area3D

@export var destination := Vector3(0, 5, 0)


func _on_body_entered(body: Node3D) -> void:
	body.global_position = destination
