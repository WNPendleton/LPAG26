class_name Player
extends CharacterBody3D

@onready var floor_surface_raycast: RayCast3D = get_node_or_null("WorldInteractions/FloorSurface")
@onready var audio: PlayerCharacterAudio = get_node_or_null("PlayerCharacterAudio")
@onready var camera: Camera3D = GlobalReferences.gameplay_camera

var spawn_point: SpawnPoint
var inventory: Array[String] = []
var input_lock = 0
var physics_lock = 0
var animation_lock = 0

func _ready() -> void:
	GlobalReferences.player_character = self
	if not is_instance_valid(floor_surface_raycast):
		push_warning("Missing floor surface raycast for player character " + str(get_path()))


func _physics_process(_delta: float) -> void:
	var material_name = "Stone"
	if is_instance_valid(floor_surface_raycast) and floor_surface_raycast.is_colliding():
		var floor_surface = floor_surface_raycast.get_collider()
		if is_instance_valid(floor_surface):
			var floor_material = floor_surface.get("physics_material_override")
			if floor_material:
				material_name = floor_material.get("resource_name")
	if material_name:
		audio.set_floor_material(material_name)


func impart_impulse(impulse: Vector3):
	velocity += impulse


func add_inventory_item(item_name: String):
	inventory.append(item_name)


func remove_inventory_item(item_name: String):
	inventory.erase(item_name)


func has_inventory_item(item_name: String):
	return inventory.has(item_name)


func set_spawn(new_spawn: SpawnPoint, do_respawn: bool = false):
	spawn_point = new_spawn
	if do_respawn:
		respawn()


func kill():
	respawn()


func respawn():
	spawn_point.spawn(self, camera)


func claim_input_lock(source: Object):
	if not input_lock:
		input_lock = source.get_instance_id()


func release_input_lock(source: Object):
	if source.get_instance_id() == input_lock:
		input_lock = 0


func claim_physics_lock(source: Object):
	if not physics_lock:
		physics_lock = source.get_instance_id()


func release_physics_lock(source: Object):
	if source.get_instance_id() == physics_lock:
		physics_lock = 0


func claim_animation_lock(source: Object):
	if not animation_lock:
		animation_lock = source.get_instance_id()


func release_animation_lock(source: Object):
	if source.get_instance_id() == animation_lock:
		animation_lock = 0


func claim_all_locks(source: Object):
	claim_input_lock(source)
	claim_physics_lock(source)
	claim_animation_lock(source)


func release_all_locks(source: Object):
	release_input_lock(source)
	release_physics_lock(source)
	release_animation_lock(source)
