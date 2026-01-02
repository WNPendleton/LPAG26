@tool
class_name InteractionTooltip
extends Sprite3D

enum tooltips {INTERACT, PICK_UP, TALK}

@onready var parent = get_parent()

var icon: Texture2D:
	set(value):
		icon = value
		update()
var tooltip := tooltips.INTERACT:
	set(value):
		tooltip = value
		update()


func _ready() -> void:
	get_node("SubViewport/Control/HBoxContainer/Label").text = get_tooltip_text()


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint(): 
		global_position = parent.global_position + Vector3(0, 2, 0)


func update():
	get_node("SubViewport/Control/HBoxContainer/TextureRect").texture = icon
	get_node("SubViewport/Control/HBoxContainer/Label").text = get_tooltip_text()


func get_tooltip_text():
	match tooltip:
		tooltips.INTERACT:
			return tr("interact_tooltip")
		tooltips.PICK_UP:
			return tr("pickup_tooltip")
		tooltips.TALK:
			return tr("talk_tooltip")
