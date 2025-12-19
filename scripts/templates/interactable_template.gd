@tool
class_name Interactable
extends Node3D

# NOTE: This script should not be used directly but it contains the basic tool
# code that generates the on-screen interaction tooltips. Scripts that extend
# Interactable should have an @tool annotation and call super._ready() in their
# _ready() function.

@onready var tooltip_prefab = preload("res://prefabs/components/interaction_tooltip.tscn")

@export var icon: Texture2D:
	set(value):
		icon = value
		update()
@export var text := "Interact":
	set(value):
		text = value
		update()

var tooltip


func _ready():
	update()
	instantiate_tooltip()


func update():
	if not has_node("InteractionTooltip"):
		if is_instance_valid(tooltip):
			tooltip.queue_free()
		if tooltip_prefab != null:
			var new_tooltip = tooltip_prefab.instantiate()
			add_child(new_tooltip)
			new_tooltip.owner = owner
	tooltip = get_node_or_null("InteractionTooltip")
	if is_instance_valid(tooltip):
		tooltip.icon = icon
		tooltip.text = text


func interact():
	push_warning("""Received a call to Interactable interact(). This probably 
	means you extended Interactable but did not define an interact() method.""")


func enable_focus():
	if is_instance_valid(tooltip):
		tooltip.show()


func disable_focus():
	if is_instance_valid(tooltip):
		tooltip.hide()


func instantiate_tooltip():
	if not Engine.is_editor_hint() and is_instance_valid(tooltip):
		tooltip.hide()
