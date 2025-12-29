extends TextureRect

@export var vignette_progress_rtpc: WwiseRTPC


func _physics_process(_delta: float) -> void:
	vignette_progress_rtpc.set_global_value(material.get("shader_parameter/progress"))


func cover():
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.0)
	GlobalReferences.player_character.claim_input_lock(self)
	Wwise.set_state("Vignette_Animation", "Vignette_Animation_On")


func cover_with_callback(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_callback(callback)
	GlobalReferences.player_character.claim_input_lock(self)
	Wwise.set_state("Vignette_Animation", "Vignette_Animation_On")


func reveal():
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 1.0)
	tween.tween_callback(func(): GlobalReferences.player_character.release_input_lock(self))
	tween.tween_callback(func(): Wwise.set_state("Vignette_Animation", "Vignette_Animation_Off"))


func reveal_with_callback(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 1.0)
	tween.tween_callback(func(): GlobalReferences.player_character.release_input_lock(self))
	tween.tween_callback(func(): Wwise.set_state("Vignette_Animation", "Vignette_Animation_Off"))
	tween.tween_callback(callback)
