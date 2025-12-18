@tool
class_name CollectibleTrail
extends Resource

signal values_changed()


@export var spacing = 3.0:
	set(value):
		spacing = value
		values_changed.emit()
@export var curve: Curve3D:
	set(value):
		curve = value
		values_changed.emit()
