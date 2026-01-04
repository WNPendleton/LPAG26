@tool
class_name Interactable
extends Node3D

# NOTE: This script contains the basic tool code that generates the on-screen
# interaction tooltips. Scripts that extend Interactable should have the @tool 
# annotation and call super._ready() in their _ready() function.

@onready var tooltip_prefab = preload("res://prefabs/components/interaction_tooltip.tscn")

@export var icon: Texture2D:
	set(value):
		icon = value
		update()
@export var tooltip: InteractionTooltip.tooltips:
	set(value):
		tooltip = value
		update()
@export var trigger: Trigger

var tooltip_node


func _ready():
	update()
	instantiate_tooltip()


func update():
	if not has_node("InteractionTooltip"):
		if is_instance_valid(tooltip_node):
			tooltip_node.queue_free()
		if tooltip_prefab != null:
			var new_tooltip = tooltip_prefab.instantiate()
			add_child(new_tooltip)
			new_tooltip.owner = owner
	tooltip_node = get_node_or_null("InteractionTooltip")
	if is_instance_valid(tooltip_node):
		tooltip_node.icon = icon
		tooltip_node.tooltip = tooltip


func interact():
	if trigger:
		trigger.trigger()
	else:
		push_warning("No trigger provided for Interactable " + str(get_path))


func enable_focus():
	if is_instance_valid(tooltip_node):
		tooltip_node.show()


func disable_focus():
	if is_instance_valid(tooltip_node):
		tooltip_node.hide()


func instantiate_tooltip():
	if not Engine.is_editor_hint() and is_instance_valid(tooltip_node):
		tooltip_node.hide()
