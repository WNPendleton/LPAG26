class_name MultiTrigger
extends Trigger

@export var triggers: Array[Trigger]


func trigger():
	for trig in triggers:
		trig.trigger()
