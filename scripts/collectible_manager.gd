@tool
extends Node

const COLLECTIBLE_SCRIPT = preload("res://scripts/collectible.gd")

@export_tool_button("Update") var update_action = _on_collectible_resources_changed
@export var collectibles: Array[CollectibleFamily]:
	set(value):
		collectibles = value
		collectibles_changed()


func _ready():
	collectibles_changed()


func collectibles_changed():
	for child in get_children():
		child.free()
	
	if not is_inside_tree():
		return
	
	for collectible_type in collectibles:
		if collectible_type != null:
			if not collectible_type.is_connected("values_changed", _on_collectible_resources_changed):
				collectible_type.connect("values_changed", _on_collectible_resources_changed)
			var member_count = 0
			for position in collectible_type.members:
				var node_name = collectible_type.name + str(member_count)
				add_collectible(collectible_type, position, node_name)
				member_count += 1
			var trail_count = 0
			for trail in collectible_type.trails:
				if trail != null:
					if not trail.is_connected("values_changed", _on_collectible_resources_changed):
						trail.connect("values_changed", _on_collectible_resources_changed)
					var curve = trail.curve
					if curve != null:
						var length = trail.curve.get_baked_length()
						var trail_member_count = 0
						while trail_member_count * trail.spacing < length:
							var position = curve.sample_baked(trail_member_count * trail.spacing)
							var node_name = collectible_type.name + "T" + str(trail_count) + "M" + str(trail_member_count)
							add_collectible(collectible_type, position, node_name)
							trail_member_count += 1
				trail_count += 1


func add_collectible(collectible_type, position, node_name):
	var new_collectible = Node3D.new()
	var new_mesh = MeshInstance3D.new()
	new_mesh.mesh = collectible_type.mesh
	new_collectible.add_child(new_mesh)
	var new_collectible_interface = Node.new()
	new_collectible_interface.set_script(COLLECTIBLE_SCRIPT)
	new_collectible_interface.vacuum_radius = collectible_type.vacuum_radius
	new_collectible_interface.collect_radius = collectible_type.collect_radius
	new_collectible_interface.sound = collectible_type.sound
	new_collectible.add_child(new_collectible_interface)
	new_collectible.position = position
	new_collectible.name = node_name
	add_child(new_collectible)
	new_collectible.owner = owner


func _on_collectible_resources_changed():
	collectibles_changed()
