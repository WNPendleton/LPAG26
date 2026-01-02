@tool
class_name Talkable
extends Interactable

## List of dialog events that might be triggered when talking to this npc.
## Events are attempted from top to bottom until one is able to be triggered.
@export var dialog_events: Array[Dialog]

var dialog_panel


func _ready():
	super._ready()
	if not Engine.is_editor_hint():
		dialog_panel = get_tree().get_root().get_node_or_null("Game/GUI/DialogPanel")
		if dialog_panel == null:
			push_warning("Unable to find dialog panel for TalkInteraction " + str(get_path()))


func interact():
	if (not dialog_panel is DialogPanel) or (not dialog_events):
		return
	for dialog in dialog_events:
		if (not dialog.key_name) or GlobalReferences.player_character.has_inventory_item(dialog.key_name):
			dialog_panel.initiate_dialog_event(dialog.dialog_ids, dialog.trigger)
			return
