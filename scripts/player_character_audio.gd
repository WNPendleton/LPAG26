class_name PlayerCharacterAudio
extends Node

@onready var character: CharacterBody3D = get_parent()


func set_floor_material(floor_material):
	Wwise.set_switch("Material_Floor", floor_material, character)


func post_footfall():
	Wwise.post_event("Play_Player_Footfall", character)


func post_jump():
	Wwise.post_event("Play_Player_Jump", character)


func post_landing():
	Wwise.post_event("Play_Player_Impact_Land", character)
