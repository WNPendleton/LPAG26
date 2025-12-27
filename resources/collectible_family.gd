@tool
class_name CollectibleFamily
extends Resource

signal values_changed

@export var name = "Collectible":
	set(value):
		name = value
		values_changed.emit()
@export var mesh: Mesh:
	set(value):
		mesh = value
		values_changed.emit()
@export var vacuum_radius = 2.0
@export var collect_radius = 0.5
@export var sound: WwiseEvent
@export var members: Array[Vector3]:
	set(value):
		members = value
		values_changed.emit()
@export var trails: Array[CollectibleTrail]:
	set(value):
		trails = value
		values_changed.emit()
@export var trigger: Script
