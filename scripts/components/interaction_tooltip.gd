@tool
extends Sprite3D

@onready var parent = get_parent()

var icon: Texture2D:
	set(value):
		icon = value
		update()
var text := "Interact":
	set(value):
		text = value
		update()


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint(): 
		global_position = parent.global_position + Vector3(0, 2, 0)


func update():
	get_node("SubViewport/Control/HBoxContainer/TextureRect").texture = icon
	get_node("SubViewport/Control/HBoxContainer/Label").text = text
