extends Node
## A controller for carriable objects' audio functionality
##
## Script determines the material of a carriable object as well as the material  
## of any environmental obstruction and sends Wwise switch data for both objects.
## It sends the last frame of object velocity to an RTPC so Wwise can attenuate
## the impact volume based on the object's velocity.

const THROWN_SWITCH_GROUP = "Material_Object" 
const SURFACE_SWITCH_GROUP = "Material_Environment" 
const RTPC_NAME = "object_velocity"
const MIN_VELOCITY = 1.0

@export var my_material_type: String = "Wood"
@export var impact_event_node: AkEvent3D

var _last_frame_velocity: Vector3 = Vector3.ZERO

@onready var parent_rb: RigidBody3D = get_parent() as RigidBody3D


func _ready():
	if parent_rb:
		parent_rb.contact_monitor = true
		parent_rb.max_contacts_reported = 2
		parent_rb.body_entered.connect(_on_body_entered)
	else:
		print("Error: AudioController must be a child of a RigidBody3D")


func _physics_process(_delta):
	var rb = get_parent()
	if rb is RigidBody3D:
		_last_frame_velocity = rb.linear_velocity


func _on_body_entered(body_node):
	var impact_speed = _last_frame_velocity.length()
	if impact_speed < MIN_VELOCITY:
		return
		
	var surface_material = "Default"
	if "physics_material_override" in body_node:
		var phys_mat = body_node.physics_material_override
		if phys_mat != null:
			if phys_mat.resource_name != "":
				surface_material = phys_mat.resource_name
			else:
				surface_material = phys_mat.resource_path.get_file().get_basename()

	Wwise.set_switch(THROWN_SWITCH_GROUP, my_material_type, impact_event_node)
	Wwise.set_switch(SURFACE_SWITCH_GROUP, surface_material, impact_event_node)
	Wwise.set_rtpc_value(RTPC_NAME, impact_speed, impact_event_node)
	
	impact_event_node.post_event()
	# Debug
	#print("Impact Speed: ", snapped(impact_speed, 0.1), " (Current actual: ",
			#snapped(parent_rb.linear_velocity(), 0.1), ")")
