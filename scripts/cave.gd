extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		Wwise.set_state("Ambience", "Cave")


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		Wwise.set_state("Ambience", "Outdoor_Sunny")
