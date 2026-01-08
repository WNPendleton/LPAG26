class_name PlayerCharacterAudio
extends Node

@onready var character: CharacterBody3D = get_parent()

@export var footfall_event: AkEvent3D
@export var land_event: AkEvent3D
@export var jump_event: AkEvent3D


func _physics_process(_delta):
	var horizontal_velocity = Vector2(character.velocity.x, character.velocity.z).length()
	Wwise.set_rtpc_value("player_horizontal_velocity", horizontal_velocity, character)


func set_floor_material(floor_material):
	Wwise.set_switch("Material_Floor", floor_material, character)


func post_footfall():
	footfall_event.post_event()


func post_jump():
	jump_event.post_event()


func post_landing():
	land_event.post_event()
