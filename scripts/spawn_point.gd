class_name SpawnPoint
extends Marker3D


func _ready() -> void:
	GlobalReferences.player_character.spawn_point = self
	spawn(GlobalReferences.player_character)


func spawn(player: Player):
	player.global_position = global_position
	player.rotation = rotation
