extends TextureRect


func cover():
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.0)
	GlobalReferences.player_character.claim_input_lock(self)


func cover_with_callback(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_callback(callback)
	GlobalReferences.player_character.claim_input_lock(self)


func reveal():
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 1.0)
	tween.tween_callback(func(): GlobalReferences.player_character.release_input_lock(self))


func reveal_with_callback(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 1.0)
	tween.tween_callback(func(): GlobalReferences.player_character.release_input_lock(self))
	tween.tween_callback(callback)
