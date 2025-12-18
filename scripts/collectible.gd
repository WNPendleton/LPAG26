class_name Collectible
extends Node

@export var vacuum_radius = 2.0
@export var collect_radius = 0.5
@export var vacuum_speed = 10.0
@export var sound: WwiseEvent

var vacuuming = false
var player: CharacterBody3D

@onready var parent = get_parent()


func _ready() -> void:
	var vacuum_area = Area3D.new()
	var vacuum_collider = CollisionShape3D.new()
	var vacuum_collider_shape = SphereShape3D.new()
	vacuum_collider_shape.radius = vacuum_radius
	vacuum_collider.shape = vacuum_collider_shape
	vacuum_area.add_child(vacuum_collider)
	vacuum_area.collision_mask = 2
	vacuum_area.connect("body_entered", _on_vacuum_entered)
	
	var collect_area = Area3D.new()
	var collect_collider = CollisionShape3D.new()
	var collect_collider_shape = SphereShape3D.new()
	collect_collider_shape.radius = collect_radius
	collect_collider.shape = collect_collider_shape
	collect_area.add_child(collect_collider)
	collect_area.collision_mask = 2
	collect_area.connect("body_entered", _on_collect_entered)
	
	var event_node = AkEvent3D.new()
	event_node.event = sound
	
	parent.add_child.call_deferred(vacuum_area)
	parent.add_child.call_deferred(collect_area)
	parent.add_child.call_deferred(event_node)


func _physics_process(delta: float) -> void:
	if vacuuming:
		var dir = parent.global_position.direction_to(player.global_position + Vector3(0, 1, 0))
		parent.global_position += dir * vacuum_speed * delta


func _on_vacuum_entered(body):
	if body is Player:
		vacuuming = true
		player = body


func _on_collect_entered(body):
	if body is Player:
		# TODO: implement actual collection logic for what this should do
		Wwise.post_event("Play_TestSound", self)
		parent.queue_free()
