extends DirectionalLight3D


func _ready() -> void:
	GlobalReferences.lightning = self


func flash(energy: float):
	rotation_degrees = Vector3(randf_range(-1, -30), randf_range(0, 360), 0)
	light_energy = energy
	var tween = get_tree().create_tween()
	tween.tween_property(self, "light_energy", 0.0, randf_range(0.5, 2.0))
