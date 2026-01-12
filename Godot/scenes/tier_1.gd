extends Node3D

@export var club_box: CSGBox3D
@export var max_distance: float = 20.0

var player_node: Node3D = null

func _process(_delta: float) -> void:
	if not player_node:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player_node = players[0]
			print("Audio Script: Player found and linked!")
		else:
			return 

	var local_player_pos = club_box.to_local(player_node.global_position)
	var half_size = club_box.size / 2.0
	var closest_point = local_player_pos.clamp(-half_size, half_size)
	var distance_to_edge = local_player_pos.distance_to(closest_point)
	
	var final_value = clamp(distance_to_edge, 0.0, max_distance)
	

	# print("Distance to Club: ", snapped(final_value, 0.1))
		
	Wwise.set_rtpc_value("distance_from_club_exterior", final_value, null)
