extends Area3D

@export var spring_power := 20.0
@export var sound: AkEvent3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.impart_impulse(Vector3(0, spring_power, 0))
		if sound:
			sound.post_event()
