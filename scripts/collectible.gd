class_name Collectible
extends Node3D

@onready var base_position = position
@onready var time = sin(position.x * position.y)
@onready var ak_area_prefab = preload("res://prefabs/components/ak_game_obj_area_3d.tscn")

@export var vacuum_radius = 2.0
@export var collect_radius = 0.5
@export var vacuum_speed = 10.0
@export var sound: WwiseEvent
@export var trigger: Trigger
@export var rotation_speed := 1.0
@export var bob_speed := 1.0

var vacuuming = false
var player: CharacterBody3D
var event_node
var disabled = false
var meshes: Array[MeshInstance3D]


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
	
	add_child.call_deferred(vacuum_area)
	(func(): vacuum_area.owner = owner).call_deferred()
	add_child.call_deferred(collect_area)
	(func(): collect_area.owner = owner).call_deferred()
	
	if sound:
		event_node = AkEvent3D.new()
		event_node.event = sound
		event_node.is_environment_aware = true
		var ak_area = ak_area_prefab.instantiate()
		add_child.call_deferred(event_node)
		(func(): event_node.owner = owner).call_deferred()
		event_node.add_child.call_deferred(ak_area)
		(func(): ak_area.owner = owner).call_deferred()
	
	for child in get_children():
		if child is MeshInstance3D:
			meshes.append(child)

func _physics_process(delta: float) -> void:
	if disabled:
		return
	time += delta
	if time > 360:
		time -= 10 * PI
	rotation.y = time
	if vacuuming:
		var dir = global_position.direction_to(player.global_position + Vector3(0, 1, 0))
		global_position += dir * vacuum_speed * delta
	else:
		for mesh in meshes:
			mesh.position.y = sin(time) * 0.1


func _on_vacuum_entered(body):
	if disabled:
		return
	if body is Player:
		vacuuming = true
		player = body


func _on_collect_entered(body):
	if disabled:
		return
	if body is Player:
		if trigger:
			trigger.trigger()
		if event_node is AkEvent3D:
			event_node.connect("end_of_event", func(_data): queue_free())
			event_node.post_event()
			disable()
		else:
			queue_free()


func disable():
	disabled = true
	hide()
