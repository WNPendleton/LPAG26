class_name TeleportObjects
extends Listener

@export var teleports: Dictionary[Node3D, Vector3]

var triggered = false


func trigger():
	if triggered:
		return
	triggered = true
	for item in teleports.keys():
		if is_instance_valid(item):
			item.global_position = teleports.get(item)
