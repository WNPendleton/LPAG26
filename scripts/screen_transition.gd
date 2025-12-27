extends TextureRect


func cover():
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.0)


func cover_with_callback(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_callback(callback)


func reveal():
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 1.0)


func reveal_with_callback(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 1.0)
	tween.tween_callback(callback)
