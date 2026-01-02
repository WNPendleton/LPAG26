extends Node

var listeners = {}


func trigger_listeners(trigger_name):
	var array = listeners.get(trigger_name)
	if not array:
		return
	for listener in array:
		listener.trigger()


func register_listener(trigger_name, listener):
	var array = listeners.get(trigger_name)
	if not array:
		array = []
	array.append(listener)
	listeners.set(trigger_name, array)
