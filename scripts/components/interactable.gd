class_name Interactable
extends Node

var tooltip
var interaction


func _ready():
	tooltip = get_parent().get_node_or_null("InteractionTooltip")
	if tooltip == null:
		push_warning("Unable to find interaction tooltip for interactable " + str(get_path()))
	else:
		tooltip.hide()
	interaction = get_node_or_null("Interaction")
	if interaction == null:
		push_warning("Unable to find interaction for interactable " + str(get_path()))


func interact():
	if is_instance_valid(interaction):
		interaction.interact()


func enable_focus():
	if is_instance_valid(tooltip):
		tooltip.show()


func disable_focus():
	if is_instance_valid(tooltip):
		tooltip.hide()
