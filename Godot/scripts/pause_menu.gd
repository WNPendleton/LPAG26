extends CanvasLayer
## Pause Menu with audio bus sliders

func _ready():
	visible = false 
	process_mode = Node.PROCESS_MODE_ALWAYS

# escape key toggle
func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		var new_state = !get_tree().paused
		get_tree().paused = new_state
		visible = new_state
		# free the mouse so you can click the sliders
		if new_state:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# functions connected from signals
func _on_main_slider_value_changed(value: float) -> void:
	Wwise.set_rtpc_value("game_volume_main", value, null)
	
	
func _on_dialogue_slider_value_changed(value: float) -> void:
	Wwise.set_rtpc_value("game_volume_dialogue", value, null)
	
	
func _on_sfx_value_changed(value: float) -> void:
	Wwise.set_rtpc_value("game_volume_sfx", value, null)


func _on_music_slider_value_changed(value: float) -> void:
	Wwise.set_rtpc_value("game_volume_music", value, null)


func _on_ambience_slider_value_changed(value: float) -> void:
	Wwise.set_rtpc_value("game_volume_ambience", value, null)
