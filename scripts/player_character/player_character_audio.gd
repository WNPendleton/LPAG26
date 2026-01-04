class_name PlayerCharacterAudio
extends Node

@onready var character: CharacterBody3D = get_parent()


func _physics_process(_delta):
	var horizontal_velocity = Vector2(character.velocity.x, character.velocity.z).length()
	Wwise.set_rtpc_value("player_horizontal_velocity", horizontal_velocity, character)


func set_floor_material(floor_material):
	Wwise.set_switch("Material_Floor", floor_material, character)


func post_footfall():
	Wwise.post_event("Play_Player_Footfall", character)


func post_jump():
	Wwise.post_event("Play_Player_Jump", character)


func post_landing():
	Wwise.post_event("Play_Player_Impact_Land", character)
