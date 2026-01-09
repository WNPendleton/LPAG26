class_name FreeObjects
extends Listener

@export var objects: Array[Node]


func trigger():
	if not objects:
		return
	for object in objects:
		object.queue_free()
