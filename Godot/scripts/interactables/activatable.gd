@tool
class_name Activatable
extends Interactable

@export var target: Node3D


func interact():
	if is_instance_valid(target) and target.has_method("activate"):
		target.activate()
	else:
		push_warning("Failed to activate activation target in " + str(get_path()))
