extends CSGBox3D

@onready var player_node: Player = GlobalReferences.player_character
@onready var half_size: Vector3 = size * 0.5


func _physics_process(_delta: float) -> void:
	var local_player_pos = to_local(player_node.global_position)
	var closest_point = local_player_pos.clamp(-half_size, half_size)
	var distance_to_edge = local_player_pos.distance_to(closest_point)
	Wwise.set_rtpc_value("distance_from_club_exterior", distance_to_edge, null)
