@tool
extends Sprite3D

var icon: Texture2D:
	set(value):
		icon = value
		update()
var text := "Interact":
	set(value):
		text = value
		update()


func update():
	get_node("SubViewport/Control/HBoxContainer/TextureRect").texture = icon
	get_node("SubViewport/Control/HBoxContainer/Label").text = text
