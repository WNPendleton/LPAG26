extends Area3D

@export var victory_message: Label


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		victory_message.show();


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		victory_message.hide();
