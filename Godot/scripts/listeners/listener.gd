class_name Listener
extends Node

## The name of the trigger signal that this listener is listening for
@export var trigger_name := ""


func _ready() -> void:
	if trigger_name:
		ListenerTriggerControl.register_listener(trigger_name, self)
