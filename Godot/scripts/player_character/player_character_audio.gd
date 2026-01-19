class_name PlayerCharacterAudio
extends Node

@onready var character: CharacterBody3D = get_parent()

@export var footfall_event: AkEvent3D
@export var land_event: AkEvent3D
@export var jump_event: AkEvent3D
@export var double_jump_event: AkEvent3D
@export var dash_event: AkEvent3D
@export var throw_event: AkEvent3D
@export var object_pickup_event: AkEvent3D
var peak_fall_velocity: float = 0.0

func _physics_process(_delta):
	var horizontal_velocity = Vector2(character.velocity.x, character.velocity.z).length()
	Wwise.set_rtpc_value("player_horizontal_velocity", horizontal_velocity, footfall_event)
	if not character.is_on_floor():
		peak_fall_velocity = abs(character.velocity.y)
	Wwise.set_rtpc_value("player_vertical_velocity", peak_fall_velocity, land_event)


func set_floor_material(floor_material):
	Wwise.set_switch("Material_Environment", floor_material, footfall_event)
	Wwise.set_switch("Material_Environment", floor_material, land_event)


func post_footfall():
	footfall_event.post_event()


func post_jump():
	jump_event.post_event()


func post_landing():
	land_event.post_event()
	

func post_double_jump():
	double_jump_event.post_event()
	
	
func post_dash():
	dash_event.post_event()
	
	
func post_object_throw():
	throw_event.post_event()
	
	
func post_object_pickup():
	object_pickup_event.post_event()
	
