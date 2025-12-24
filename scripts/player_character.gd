class_name Player
extends CharacterBody3D

@onready var floor_surface_raycast: RayCast3D = get_node_or_null("FloorSurface")
@onready var audio: PlayerCharacterAudio = get_node_or_null("PlayerCharacterAudio")


func _ready() -> void:
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
