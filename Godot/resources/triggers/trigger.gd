class_name Trigger
extends Resource

@export var trigger_name := ""

func trigger():
	ListenerTriggerControl.trigger_listeners(trigger_name)
