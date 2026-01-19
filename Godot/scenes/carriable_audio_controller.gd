extends Node

@export var my_material_type: String = "Wood"
const THROWN_SWITCH_GROUP = "Material_Object" 
const SURFACE_SWITCH_GROUP = "Material_Environment" 
const RTPC_NAME = "object_velocity"
@export var impact_event_node: AkEvent3D
const MIN_VELOCITY = 1.0
var _last_frame_velocity: Vector3 = Vector3.ZERO


func _ready():
	var rb = get_parent()
	if rb is RigidBody3D:
		rb.contact_monitor = true
		rb.max_contacts_reported = 2
		rb.body_entered.connect(_on_body_entered)
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
	# print("Impact Speed: ", snapped(impact_speed, 0.1), " (Current actual: ", snapped(rb.linear_velocity.length(), 0.1), ")")
