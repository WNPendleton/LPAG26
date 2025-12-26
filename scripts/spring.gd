extends Area3D

@export var spring_power := 20.0
@export var sound: WwiseEvent


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.impart_impulse(Vector3(0, spring_power, 0))
		if sound:
			Wwise.post_event(sound.name, self)
