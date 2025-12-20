@tool
class_name Carriable
extends Interactable

@onready var original_parent = get_parent()

var carried = false
var original_collision_layer
var original_collision_mask


func _ready():
	super._ready()
	var node = self
	if node is RigidBody3D:
		original_collision_layer = node.collision_layer
		original_collision_mask = node.collision_mask


func pick_up(carry_point: Node3D):
	carried = true
	reparent(carry_point)
	var goal_transform = Transform3D()
	var transform_tween = get_tree().create_tween()
	transform_tween.tween_property(self, "transform", goal_transform, 0.1)
	var node = self
	if node is RigidBody3D:
		node.freeze = true
		node.collision_layer = 0
		node.collision_mask = 0


func put_down(velocity):
	carried = false
	reparent(original_parent)
	var node = self
	if node is RigidBody3D:
		node.freeze = false
		node.collision_layer = original_collision_layer
		node.collision_mask = original_collision_mask
		node.linear_velocity = velocity


func throw(velocity: Vector3, throw_power: float):
	carried = false
	reparent(original_parent)
	var node = self
	if node is RigidBody3D:
		node.freeze = false
		node.collision_layer = original_collision_layer
		node.collision_mask = original_collision_mask
		node.linear_velocity = velocity + Vector3(0, throw_power, throw_power * -2).rotated(Vector3.UP, basis.get_euler().y)
