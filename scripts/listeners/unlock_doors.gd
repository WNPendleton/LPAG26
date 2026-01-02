class_name UnlockDoors
extends Listener

@export var doors: Array[InteriorDoor]


func trigger():
	for door in doors:
		door.unlock()
