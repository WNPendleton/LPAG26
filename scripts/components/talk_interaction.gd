extends Node

@export_multiline var dialog: Array[String]

var dialog_panel


func _ready() -> void:
	dialog_panel = get_tree().get_root().get_node_or_null("Game/GUI/DialogPanel")
	if dialog_panel == null:
		push_warning("Unable to find dialog panel for TalkInteraction " + str(get_path()))

func interact():
	if dialog_panel is DialogPanel:
		dialog_panel.display(dialog)
